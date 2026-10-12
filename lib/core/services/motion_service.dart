import 'dart:math' as math;

import 'package:beneathsos_app/features/measurement/domain/motion_port.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sensors_plus/sensors_plus.dart';

part 'motion_service.g.dart';

/// The only place that talks to `sensors_plus`. Implements [MotionPort].
class MotionService implements MotionPort {
  @override
  Stream<double> get accelerations =>
      userAccelerometerEventStream(samplingPeriod: SensorInterval.uiInterval)
          .map((e) => math.sqrt(e.x * e.x + e.y * e.y + e.z * e.z))
          // A phone without the sensor reports an error: then it simply counts as still.
          .handleError((Object _) {});
}

/// The motion sensor.
@Riverpod(keepAlive: true)
MotionPort motionPort(Ref ref) => MotionService();
