import 'package:beneathsos_app/core/settings/domain/app_settings.dart';
import 'package:beneathsos_app/core/settings/domain/settings_store.dart';
import 'package:rubble_core/rubble_core.dart';

/// Stores what the rescuer chose in Settings.
final class UpdateSettings {
  /// Creates the use case on [_store].
  const UpdateSettings(this._store);

  final SettingsStore _store;

  /// The app's language.
  Future<void> language(AppLanguage value) =>
      _store.write(AppSettings.languageKey, value.name);

  /// The engine profile of new searches (one of [rubbleTypes]).
  Future<void> defaultProfile(String id) =>
      _store.write(AppSettings.profileKey, id);

  /// Whether the signal circles are shown.
  Future<void> signalCircles({required bool shown}) =>
      _store.write(AppSettings.circlesKey, '$shown');

  /// Still time per measuring point (one of [measureSecondsChoices]).
  Future<void> measureDuration(Duration value) =>
      _store.write(AppSettings.measureKey, '${value.inSeconds}');

  /// The rubble height assumed without a depth.
  Future<void> defaultRubbleHeight(Meters value) =>
      _store.write(AppSettings.heightKey, '${value.value}');
}
