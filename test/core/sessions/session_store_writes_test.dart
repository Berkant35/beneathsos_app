import 'dart:math';

import 'package:beneathsos_app/core/database/app_database.dart';
import 'package:beneathsos_app/core/sessions/data/drift_session_store.dart';
import 'package:drift/drift.dart' show OrderingTerm;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubble_core/rubble_core.dart';

void main() {
  late AppDatabase db;
  var wall = 5000;

  DriftSessionStore store() =>
      DriftSessionStore(db, nowMs: () => wall, random: Random(1));

  Future<SessionId> practice(DriftSessionStore s) => s.create(
    title: 'Practice search',
    engineProfile: 'voided_pancake@1',
    practice: true,
  );

  setUp(() {
    wall = 5000;
    db = AppDatabase(NativeDatabase.memory());
  });
  tearDown(() => db.close());

  test('create stores the session and its SiteCreated event', () async {
    final id = await practice(store());
    final session = await db.select(db.sessions).getSingle();
    expect(session.id, id.value);
    expect(
      (session.title, session.practice, session.closedAt),
      ('Practice search', true, null),
    );
    final event = await db.select(db.events).getSingle();
    expect(
      (event.sessionId, event.seq, event.type),
      (id.value, 1, 'SiteCreated'),
    );
  });

  test('a session whose first event cannot be stored is not created', () async {
    final s = store();
    await practice(s);
    await db.customStatement('ALTER TABLE events RENAME TO events_gone');
    await expectLater(practice(s), throwsA(isA<SqliteException>()));
    expect(await db.select(db.sessions).get(), hasLength(1));
  });

  test('appends get the next sequence number and a later timestamp', () async {
    final s = store();
    final id = await practice(s);
    await s.append(id, ScaleSet(factor: 1.1, source: ScaleSource.tape));
    await s.append(id, const SessionClosed());
    final rows = await (db.select(
      db.events,
    )..orderBy([(e) => OrderingTerm.asc(e.seq)])).get();
    expect(rows.map((r) => r.seq), [1, 2, 3]);
    final stamps = rows.map((r) => r.hlc).toList();
    expect([...stamps]..sort(), stamps);
    expect(stamps.toSet(), hasLength(3));
  });

  test('appends started together still get unique sequence numbers', () async {
    final s = store();
    final id = await practice(s);
    await Future.wait([
      for (var i = 0; i < 5; i++)
        s.append(id, BlacklistEdited(added: ['k$i'], removed: const [])),
    ]);
    final rows = await db.select(db.events).get();
    expect(rows.map((r) => r.seq).toSet(), {1, 2, 3, 4, 5, 6});
  });

  test('the device id is created once and reused after a restart', () async {
    await practice(store());
    await practice(store());
    final devices = (await db.select(db.events).get()).map((r) => r.deviceId);
    expect(devices.toSet(), hasLength(1));
    expect(await db.select(db.settings).get(), hasLength(1));
  });

  test('after a restart with the wall clock set back, events still sort after the stored ones', () async {
    final id = await practice(store());
    wall = 1000;
    await store().append(id, const SessionClosed());
    final rows = await (db.select(
      db.events,
    )..orderBy([(e) => OrderingTerm.asc(e.seq)])).get();
    expect(rows.map((r) => r.seq), [1, 2]);
    expect(rows[1].hlc.compareTo(rows[0].hlc), greaterThan(0));
  });

  test('SessionClosed records when the session was closed', () async {
    final s = store();
    final id = await practice(s);
    wall = 9000;
    await s.append(id, const SessionClosed());
    expect((await db.select(db.sessions).getSingle()).closedAt, 9000);
  });

  test('an append to an unknown session fails and stores nothing', () async {
    final s = store();
    await practice(s);
    await expectLater(
      s.append(const SessionId('missing'), const SessionClosed()),
      throwsA(isA<SqliteException>()),
    );
    expect(await db.select(db.events).get(), hasLength(1));
  });
}
