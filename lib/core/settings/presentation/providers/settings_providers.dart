import 'package:beneathsos_app/core/database/database_provider.dart';
import 'package:beneathsos_app/core/settings/data/drift_settings_store.dart';
import 'package:beneathsos_app/core/settings/domain/settings_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_providers.g.dart';

/// Settings on the app database.
@Riverpod(keepAlive: true)
SettingsStore settingsStore(Ref ref) =>
    DriftSettingsStore(ref.watch(appDatabaseProvider));
