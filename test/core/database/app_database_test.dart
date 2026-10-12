import 'package:beneathsos_app/core/database/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<void> addSession(String id) => db
      .into(db.sessions)
      .insert(
        SessionsCompanion.insert(
          id: id,
          title: 'Practice search',
          engineProfile: 'voided_pancake@1',
          practice: true,
          createdAt: 1000,
        ),
      );

  Future<void> addEvent(String id, {String session = 's1', int seq = 1}) => db
      .into(db.events)
      .insert(
        EventsCompanion.insert(
          id: id,
          sessionId: session,
          seq: seq,
          deviceId: 'device-a',
          hlc: '000000000001000-00000000-device-a',
          schema: 1,
          type: 'SessionClosed',
          payload: '{}',
          createdAt: 1000,
        ),
      );

  Future<void> addSample() => db
      .into(db.rssiSamples)
      .insert(
        RssiSamplesCompanion.insert(
          sessionId: 's1',
          peripheralKey: 'apple-1',
          rssi: -71,
          tMonoNs: 1,
          tWall: 1000,
        ),
      );

  test('events are append-only: an update is rejected', () async {
    await addSession('s1');
    await addEvent('e1');
    await expectLater(
      db.customUpdate("UPDATE events SET type = 'Teleported'"),
      throwsA(isA<SqliteException>()),
    );
    final row = await db.select(db.events).getSingle();
    expect(row.type, 'SessionClosed');
  });

  test('a device cannot use a sequence number twice in a session', () async {
    await addSession('s1');
    await addEvent('e1');
    await expectLater(addEvent('e2'), throwsA(isA<SqliteException>()));
  });

  test('an event needs an existing session (foreign keys are on)', () async {
    await expectLater(
      addEvent('e1', session: 'missing'),
      throwsA(isA<SqliteException>()),
    );
  });

  test('deleting a session removes its events and samples', () async {
    await addSession('s1');
    await addEvent('e1');
    await addSample();
    await db.delete(db.sessions).go();
    expect(await db.select(db.events).get(), isEmpty);
    expect(await db.select(db.rssiSamples).get(), isEmpty);
  });

  test('settings store a value by key', () async {
    await db
        .into(db.settings)
        .insert(SettingsCompanion.insert(key: 'device_id', value: 'abc'));
    final row = await db.select(db.settings).getSingle();
    expect((row.key, row.value), ('device_id', 'abc'));
  });
}
