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
  Stream<SessionState> watch(SessionId session) => throw UnimplementedError();

  @override
  Stream<SessionSummary?> watchLatestOpen() => throw UnimplementedError();

  @override
  Future<void> addSamples(
    SessionId session,
    PointId? point,
    List<BleSample> samples,
  ) => throw UnimplementedError();
}
