import 'package:beneathsos_app/core/database/app_database.dart';
import 'package:beneathsos_app/core/settings/data/drift_settings_store.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late DriftSettingsStore settings;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    settings = DriftSettingsStore(db);
  });
  tearDown(() => db.close());

  test('an unknown key reads as null', () async {
    expect(await settings.watch('disclaimer_accepted').first, isNull);
  });

  test('a written value is read back and replaces the old one', () async {
    await settings.write('disclaimer_accepted', '1');
    expect(await settings.watch('disclaimer_accepted').first, '1');
    await settings.write('disclaimer_accepted', '2');
    expect(await settings.watch('disclaimer_accepted').first, '2');
    expect(await db.select(db.settings).get(), hasLength(1));
  });

  test('watchers see a later write', () async {
    final values = settings.watch('units');
    final expectation = expectLater(values, emitsThrough('metric'));
    await settings.write('units', 'metric');
    await expectation;
  });
}
