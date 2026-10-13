import 'package:rubble_core/rubble_core.dart';

/// Air pressure readings of this phone; silent on a phone without a barometer.
abstract interface class BarometerPort {
  /// Readings as they come.
  Stream<Hpa> get pressures;
}
