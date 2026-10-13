import 'package:meta/meta.dart';
import 'package:rubble_core/rubble_core.dart';

/// The language the app speaks.
enum AppLanguage {
  /// The phone's language.
  system,

  /// Türkçe.
  turkish,

  /// English.
  english,
}

/// The engine profiles a rescuer can choose as the default rubble type.
const rubbleTypes = ['voided_pancake@1', 'dense@1'];

/// The measuring times a rescuer can choose (seconds).
const measureSecondsChoices = [10, 15, 30];

/// The default rubble heights offered (metres).
const rubbleHeightChoices = [3.0, 4.0, 6.0, 9.0, 12.0];

/// What the rescuer chose in Settings; every value has a default, and a stored value that does not
/// read falls back to it.
@immutable
final class AppSettings {
  /// Creates settings.
  const AppSettings({
    this.language = AppLanguage.system,
    this.defaultProfile = 'voided_pancake@1',
    this.signalCircles = true,
    this.measureDuration = const Duration(seconds: 15),
    this.defaultRubbleHeight = const Meters(4),
  });

  /// The settings from stored values ([value] of a key, null when never written).
  factory AppSettings.read(String? Function(String key) value) {
    const d = AppSettings();
    final language = AppLanguage.values.asNameMap()[value(languageKey)];
    final profile = value(profileKey);
    final seconds = int.tryParse(value(measureKey) ?? '');
    final height = double.tryParse(value(heightKey) ?? '');
    return AppSettings(
      language: language ?? d.language,
      defaultProfile: rubbleTypes.contains(profile)
          ? profile!
          : d.defaultProfile,
      signalCircles: switch (value(circlesKey)) {
        'true' => true,
        'false' => false,
        _ => d.signalCircles,
      },
      measureDuration: measureSecondsChoices.contains(seconds)
          ? Duration(seconds: seconds!)
          : d.measureDuration,
      defaultRubbleHeight: height != null && height > 0 && height <= 100
          ? Meters(height)
          : d.defaultRubbleHeight,
    );
  }

  /// Settings-store key of [language].
  static const languageKey = 'language';

  /// Settings-store key of [defaultProfile].
  static const profileKey = 'default_profile';

  /// Settings-store key of [signalCircles].
  static const circlesKey = 'signal_circles';

  /// Settings-store key of [measureDuration] (seconds).
  static const measureKey = 'measure_seconds';

  /// Settings-store key of [defaultRubbleHeight] (metres).
  static const heightKey = 'default_rubble_height';

  /// The app's language.
  final AppLanguage language;

  /// The engine profile of a new search.
  final String defaultProfile;

  /// Whether the signal circles are shown.
  final bool signalCircles;

  /// Still time per measuring point.
  final Duration measureDuration;

  /// The rubble height the map assumes when a search has no depth.
  final Meters defaultRubbleHeight;

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.language == language &&
      other.defaultProfile == defaultProfile &&
      other.signalCircles == signalCircles &&
      other.measureDuration == measureDuration &&
      other.defaultRubbleHeight == defaultRubbleHeight;

  @override
  int get hashCode => Object.hash(
    language,
    defaultProfile,
    signalCircles,
    measureDuration,
    defaultRubbleHeight,
  );
}
