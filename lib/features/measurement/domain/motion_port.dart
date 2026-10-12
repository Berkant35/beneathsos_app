/// What measuring needs from the motion sensor.
abstract interface class MotionPort {
  /// Accelerations of the phone in m/s² with gravity removed (empty without a sensor).
  Stream<double> get accelerations;
}
