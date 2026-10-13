import 'package:rubble_core/rubble_core.dart';

/// Near the ground, air pressure rises about 1 hPa every 8.3 m down.
const metresPerHpa = 8.3;

/// Two phones' barometers can differ by about this much, so every reading is ± this (metres).
const barometerUncertaintyM = 8.0;

/// A coarse depth class — never more precise than the barometers allow (rule 2: not from the signal).
enum BarometricDepth {
  /// More than 4 m above the rescuer.
  above,

  /// Within 4 m of the rescuer's level.
  level,

  /// 4–12 m below: about one to three floors.
  below,

  /// More than 12 m below.
  deep,
}

/// How far below the rescuer a trapped phone is, from its air pressure [phone] and the rescuer's
/// [rescuer]: the metres (negative = above) and a coarse class.
({Meters below, BarometricDepth depthClass}) barometricDepth(
  Hpa phone,
  Hpa rescuer,
) {
  final below = (phone.value - rescuer.value) * metresPerHpa;
  return (
    below: Meters(below),
    depthClass: switch (below) {
      < -4 => BarometricDepth.above,
      <= 4 => BarometricDepth.level,
      <= 12 => BarometricDepth.below,
      _ => BarometricDepth.deep,
    },
  );
}
