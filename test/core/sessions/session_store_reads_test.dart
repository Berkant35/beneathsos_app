import 'dart:io';
import 'dart:math';

import 'package:beneathsos_app/core/database/app_database.dart';
import 'package:beneathsos_app/core/models/ble_sample.dart';
import 'package:beneathsos_app/core/sessions/data/drift_session_store.dart';
import 'package:beneathsos_app/core/sessions/domain/session_store.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubble_core/rubble_core.dart';

void main() {
  late AppDatabase db;
  var wall = 5000;

  DriftSessionStore store() =>
      DriftSessionStore(db, nowMs: () => wall, random: Random(1));

  Future<SessionId> create(DriftSessionStore s, String title) =>
      s.create(title: title, engineProfile: 'voided_pancake@1', practice: true);

  Future<void> measure(DriftSessionStore s, SessionId id, String point) async {
    await s.append(
      id,
      MeasurementPointPlaced(
        point: PointId(point),
        at: const SitePoint(Meters(2), Meters(3)),
      ),
    );
    await s.append(
      id,
      MeasurementCompleted(
        point: PointId(point),
        duration: const Duration(seconds: 15),
        readings: [
          SignalHeard(
            const TargetId('t1'),
            median: const Dbm(-71),
            samples: 30,
          ),
        ],
      ),
    );
  }

  setUp(() {
    wall = 5000;
    db = AppDatabase(NativeDatabase.memory());
  });
  tearDown(() => db.close());

  test('watch emits the replayed session and follows new events', () async {
    final s = store();
    final id = await create(s, 'Practice search');
    final states = s.watch(id);
    await expectLater(
      states,
      emits(
        predicate<SessionState>(
          (st) => st.title == 'Practice search' && !st.closed,
        ),
      ),
    );
    await s.append(id, const SessionClosed());
    await expectLater(
      s.watch(id),
      emits(predicate<SessionState>((st) => st.closed)),
    );
  });

  test(
    'a stored event that no longer decodes is reported, not skipped',
    () async {
      final s = store();
      final id = await create(s, 'Practice search');
      for (final (eventId, payload) in [
        ('bad-json', '{"factor": '),
        ('bad-value', '{"factor": 0, "source": "tape"}'),
      ]) {
        await db.customStatement('DELETE FROM events WHERE id IN (?, ?)', [
          'bad-json',
          'bad-value',
        ]);
        await db
            .into(db.events)
            .insert(
              EventsCompanion.insert(
                id: eventId,
                sessionId: id.value,
                seq: 99,
                deviceId: 'device-x',
                hlc: '000000000009000-00000000-device-x',
                schema: 1,
                type: 'ScaleSet',
                payload: payload,
                createdAt: 9000,
              ),
            );
        await expectLater(
          s.watch(id),
          emitsError(
            isA<UnreadableEvent>().having(
              (e) => e.eventId.value,
              'id',
              eventId,
            ),
          ),
        );
      }
    },
  );

  test('the latest open session is summarised until it is closed', () async {
    final s = store();
    final first = await create(s, 'First');
    wall = 6000;
    final second = await create(s, 'Second');
    await measure(s, second, 'p1');
    await expectLater(
      s.watchLatestOpen(),
      emits(
        SessionSummary(
          id: second,
          title: 'Second',
          practice: true,
          createdAt: DateTime.fromMillisecondsSinceEpoch(6000),
          measuredPoints: 1,
        ),
      ),
    );
    await s.append(second, const SessionClosed());
    await expectLater(
      s.watchLatestOpen(),
      emits(isA<SessionSummary>().having((x) => x.id, 'id', first)),
    );
    await s.append(first, const SessionClosed());
    await expectLater(s.watchLatestOpen(), emits(isNull));
  });

  test('the summary follows new measurements', () async {
    final s = store();
    final id = await create(s, 'Practice search');
    final counts = s.watchLatestOpen().map((x) => x?.measuredPoints);
    final expectation = expectLater(counts, emitsThrough(1));
    await measure(s, id, 'p1');
    await expectation;
  });

  test('raw samples are stored with their session and point', () async {
    final s = store();
    final id = await create(s, 'Practice search');
    await s.addSamples(id, const PointId('p1'), [
      for (var i = 0; i < 3; i++)
        BleSample(
          key: 'apple-1',
          rssi: -70 - i,
          serviceUuids: const [],
          monotonicNanos: i,
          wallClockMillis: 5000 + i,
          companyId: 0x004c,
          txPower: -12,
        ),
    ]);
    final rows = await db.select(db.rssiSamples).get();
    expect(rows.map((r) => r.rssi), [-70, -71, -72]);
    expect(rows.first.sessionId, id.value);
    expect(rows.first.pointId, 'p1');
    expect((rows.first.companyId, rows.first.txPower), (0x004c, -12));
  });

  test('a session survives closing and reopening the database file', () async {
    final dir = await Directory.systemTemp.createTemp('beneathsos_db');
    addTearDown(() => dir.delete(recursive: true));
    final file = File('${dir.path}/beneathsos.sqlite');
    var onDisk = AppDatabase(NativeDatabase(file));
    final id = await DriftSessionStore(
      onDisk,
      nowMs: () => wall,
      random: Random(1),
    ).create(title: 'Kept', engineProfile: 'dense@1', practice: false);
    await onDisk.close();

    onDisk = AppDatabase(NativeDatabase(file));
    addTearDown(onDisk.close);
    final reopened = DriftSessionStore(
      onDisk,
      nowMs: () => wall,
      random: Random(2),
    );
    await measure(reopened, id, 'p1');
    final state = await reopened.watch(id).first;
    expect(state.title, 'Kept');
    expect(state.measuredPoints, hasLength(1));
  });
}
