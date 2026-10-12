import 'package:beneathsos_app/core/database/app_database.dart';
import 'package:beneathsos_app/core/settings/domain/settings_store.dart';

/// [SettingsStore] on the `settings` table.
final class DriftSettingsStore implements SettingsStore {
  /// Creates the store on [_db].
  DriftSettingsStore(this._db);

  final AppDatabase _db;

  @override
  Stream<String?> watch(String key) =>
      (_db.select(_db.settings)..where((s) => s.key.equals(key)))
          .watchSingleOrNull()
          .map((row) => row?.value);

  @override
  Future<void> write(String key, String value) => _db
      .into(_db.settings)
      .insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: value));
}
