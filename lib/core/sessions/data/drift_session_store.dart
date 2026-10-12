import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:beneathsos_app/core/database/app_database.dart';
import 'package:beneathsos_app/core/models/ble_sample.dart';
import 'package:beneathsos_app/core/sessions/domain/session_store.dart';
import 'package:drift/drift.dart';
import 'package:rubble_core/rubble_core.dart';

typedef _Identity = ({DeviceId device, HybridClock clock});

/// [SessionStore] on the app's Drift database.
final class DriftSessionStore implements SessionStore {
  /// Creates the store; [nowMs] is the wall clock and [random] feeds the ids (injected for tests).
  DriftSessionStore(
    this._db, {
    required int Function() nowMs,
    required Random random,
  }) : _nowMs = nowMs,
       _ids = Uuid7Generator(nowMs: nowMs, random: random);

  static const _deviceKey = 'device_id';

  final AppDatabase _db;
  final int Function() _nowMs;
  final Uuid7Generator _ids;
  Future<_Identity>? _identity;

  /// This device's id (created once, kept in `settings`) and a clock seeded with the greatest
  /// stored timestamp, so a wall clock set back while the app was closed cannot reorder events.
  Future<_Identity> _ready() => _identity ??= _loadIdentity().catchError((
    Object error,
    StackTrace stack,
  ) {
    _identity = null; // try again on the next call
    Error.throwWithStackTrace(error, stack);
  });

  Future<_Identity> _loadIdentity() => _db.transaction(() async {
    final stored = await (_db.select(
      _db.settings,
    )..where((s) => s.key.equals(_deviceKey))).getSingleOrNull();
    final device = DeviceId(stored?.value ?? _ids.next().value);
    if (stored == null) {
      await _db
          .into(_db.settings)
          .insert(
            SettingsCompanion.insert(key: _deviceKey, value: device.value),
          );
    }
    final last = await _db
        .customSelect('SELECT MAX(hlc) AS last FROM events')
        .map((row) => row.readNullable<String>('last'))
        .getSingle();
    return (
      device: device,
      clock: HybridClock(
        device: device,
        nowMs: _nowMs,
        last: last == null ? null : HybridTimestamp.parse(last),
      ),
    );
  });

  @override
  Future<SessionId> create({
    required String title,
    required String engineProfile,
    required bool practice,
  }) async {
    final identity = await _ready();
    final id = SessionId(_ids.next().value);
    await _db.transaction(() async {
      await _db
          .into(_db.sessions)
          .insert(
            SessionsCompanion.insert(
              id: id.value,
              title: title,
              engineProfile: engineProfile,
              practice: practice,
              createdAt: _nowMs(),
            ),
          );
      await _insert(
        identity,
        id,
        SiteCreated(title: title, engineProfile: engineProfile),
      );
    });
    return id;
  }

  @override
  Future<void> append(SessionId session, SessionEvent event) async {
    final identity = await _ready();
    await _db.transaction(() async {
      await _insert(identity, session, event);
      if (event is SessionClosed) {
        await (_db.update(_db.sessions)
              ..where((s) => s.id.equals(session.value)))
            .write(SessionsCompanion(closedAt: Value(_nowMs())));
      }
    });
  }

  /// Inserts [event] with the next sequence number of this device; runs inside a transaction, so
  /// appends started together are numbered one after the other.
  Future<void> _insert(
    _Identity identity,
    SessionId session,
    SessionEvent event,
  ) async {
    final last = await _db
        .customSelect(
          'SELECT MAX(seq) AS last FROM events WHERE session_id = ? AND device_id = ?',
          variables: [
            Variable.withString(session.value),
            Variable.withString(identity.device.value),
          ],
        )
        .map((row) => row.readNullable<int>('last'))
        .getSingle();
    final envelope = EventEnvelope(
      id: EventId(_ids.next().value),
      session: session,
      seq: (last ?? 0) + 1,
      hlc: identity.clock.now(),
      event: event,
    );
    await _db
        .into(_db.events)
        .insert(
          EventsCompanion.insert(
            id: envelope.id.value,
            sessionId: session.value,
            seq: envelope.seq,
            deviceId: identity.device.value,
            hlc: envelope.hlc.serialize(),
            schema: EventEnvelope.schemaVersion,
            type: event.type,
            payload: jsonEncode(event.payloadJson()),
            createdAt: _nowMs(),
          ),
        );
  }

  @override
  Stream<SessionState> watch(SessionId session) =>
      (_db.select(_db.events)..where((e) => e.sessionId.equals(session.value)))
          .watch()
          .map((rows) => SessionProjection.replay(rows.map(_decode)));

  @override
  Stream<SessionSummary?> watchLatestOpen() => _db
      .customSelect(
        'SELECT id FROM sessions WHERE closed_at IS NULL '
        'ORDER BY practice ASC, created_at DESC, id DESC LIMIT 1',
        readsFrom: {_db.sessions, _db.events},
      )
      .watch()
      .asyncMap(
        (rows) => rows.isEmpty
            ? Future<SessionSummary?>.value()
            : _summary(rows.single.read<String>('id')),
      );

  Future<SessionSummary> _summary(String id) async {
    final session = await (_db.select(
      _db.sessions,
    )..where((s) => s.id.equals(id))).getSingle();
    final events = await (_db.select(
      _db.events,
    )..where((e) => e.sessionId.equals(id))).get();
    return _summaryOf(session, events);
  }

  @override
  Stream<List<SessionSummary>> watchSearches() {
    final searches = _db.select(_db.sessions)
      ..where((s) => s.practice.equals(false))
      ..orderBy([
        (s) => OrderingTerm.asc(s.closedAt.isNotNull()),
        (s) => OrderingTerm.desc(s.createdAt),
        (s) => OrderingTerm.desc(s.id),
      ]);
    return _db
        .customSelect('SELECT 1', readsFrom: {_db.sessions, _db.events})
        .watch()
        .asyncMap((_) async {
          final sessions = await searches.get();
          final events =
              await (_db.select(_db.events)..where(
                    (e) => e.sessionId.isIn([for (final s in sessions) s.id]),
                  ))
                  .get();
          final bySession = <String, List<EventRow>>{};
          for (final e in events) {
            (bySession[e.sessionId] ??= []).add(e);
          }
          return [
            for (final s in sessions)
              _summaryOf(s, bySession[s.id] ?? const []),
          ];
        });
  }

  static SessionSummary _summaryOf(SessionRow session, List<EventRow> events) {
    SessionState? state;
    try {
      state = SessionProjection.replay(events.map(_decode));
    } on UnreadableEvent {
      state = null; // watch(id) reports the event; the search itself stays reachable
    }
    return SessionSummary(
      id: SessionId(session.id),
      title: session.title,
      practice: session.practice,
      createdAt: DateTime.fromMillisecondsSinceEpoch(session.createdAt),
      measuredPoints: state?.measuredPoints.length ?? 0,
      readable: state != null,
      closedAt: session.closedAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(session.closedAt!),
    );
  }

  /// Rebuilds the envelope of a stored row; a row that no longer decodes is an [UnreadableEvent].
  static EventEnvelope _decode(EventRow row) {
    try {
      return EventEnvelope.fromJson({
        'schema': row.schema,
        'id': row.id,
        'session': row.sessionId,
        'seq': row.seq,
        'hlc': row.hlc,
        'type': row.type,
        'payload': jsonDecode(row.payload),
      });
    } on FormatException catch (e) {
      // rubble_core decoding reports anything invalid (also values its constructors reject) as a
      // FormatException; jsonDecode does the same for broken JSON.
      throw UnreadableEvent(EventId(row.id), e.message);
    }
  }

  @override
  Future<void> addSamples(
    SessionId session,
    PointId? point,
    List<BleSample> samples,
  ) => _db.batch(
    (batch) => batch.insertAll(_db.rssiSamples, [
      for (final s in samples)
        RssiSamplesCompanion.insert(
          sessionId: session.value,
          pointId: Value(point?.value),
          peripheralKey: s.key,
          rssi: s.rssi,
          txPower: Value(s.txPower),
          companyId: Value(s.companyId),
          tMonoNs: s.monotonicNanos,
          tWall: s.wallClockMillis,
        ),
    ]),
  );
}
