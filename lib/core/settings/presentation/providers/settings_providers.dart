import 'package:beneathsos_app/core/database/database_provider.dart';
import 'package:beneathsos_app/core/settings/data/drift_settings_store.dart';
import 'package:beneathsos_app/core/settings/domain/app_settings.dart';
import 'package:beneathsos_app/core/settings/domain/settings_store.dart';
import 'package:beneathsos_app/core/settings/domain/update_settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_providers.g.dart';

/// Settings on the app database.
@Riverpod(keepAlive: true)
SettingsStore settingsStore(Ref ref) =>
    DriftSettingsStore(ref.watch(appDatabaseProvider));

/// One stored setting, following every write.
@Riverpod(keepAlive: true)
Stream<String?> settingValue(Ref ref, String key) =>
    ref.watch(settingsStoreProvider).watch(key);

/// What the rescuer chose in Settings (the defaults until the stored values are read).
@Riverpod(keepAlive: true)
AppSettings appSettings(Ref ref) =>
    AppSettings.read((key) => ref.watch(settingValueProvider(key)).value);

/// Stores Settings.
@Riverpod(keepAlive: true)
UpdateSettings updateSettings(Ref ref) =>
    UpdateSettings(ref.watch(settingsStoreProvider));
