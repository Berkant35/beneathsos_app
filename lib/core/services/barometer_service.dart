import 'package:beneathsos_app/core/sensors/domain/barometer_port.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rubble_core/rubble_core.dart';
import 'package:sensors_plus/sensors_plus.dart';

part 'barometer_service.g.dart';

/// The barometer through `sensors_plus` (CoreMotion's altimeter on iOS). Implements [BarometerPort].
class BarometerService implements BarometerPort {
  @override
  Stream<Hpa> get pressures => barometerEventStream()
      .map((e) => Hpa(e.pressure))
      // A phone without a barometer reports an error: then it simply sends none.
      .handleError((Object _) {});
}

/// The barometer.
@Riverpod(keepAlive: true)
BarometerPort barometerPort(Ref ref) => BarometerService();

/// This phone's air pressure, while a screen needs it (to compare with a trapped phone's).
@riverpod
Stream<Hpa> rescuerPressure(Ref ref) =>
    ref.watch(barometerPortProvider).pressures;
