import 'package:rubble_core/rubble_core.dart';

/// A suggestion that a target now uses another Bluetooth identity.
typedef RelinkSuggestion = ({
  TargetId target,
  String from,
  String to,
  int gapSeconds,
});

/// Where measuring stands.
sealed class MeasurementState {
  const MeasurementState();
}

/// Waiting for the rescuer to tap where they stand ([pending], not stored yet: it can be moved by
/// tapping elsewhere) and start; [last] says how the previous point went.
final class ChoosingPoint extends MeasurementState {
  /// Creates the state.
  const ChoosingPoint({this.last, this.pending});

  /// The previous point's result, if one was just measured.
  final MeasurementOutcome? last;

  /// Where the next point will be, once the rescuer starts.
  final SitePoint? pending;
}

/// Measuring at [at]: [remaining] still time, [moving] pauses it, [heard] readings per target so far.
final class Measuring extends MeasurementState {
  /// Creates the state.
  const Measuring({
    required this.point,
    required this.at,
    required this.remaining,
    required this.moving,
    required this.heard,
    this.relink,
  });

  /// The point.
  final PointId point;

  /// Where it is.
  final SitePoint at;

  /// Still time left.
  final Duration remaining;

  /// The rescuer is moving: the countdown waits.
  final bool moving;

  /// Readings of each target so far.
  final Map<TargetId, int> heard;

  /// A possible identity change of a target, for the rescuer to confirm.
  final RelinkSuggestion? relink;
}

/// The point is being stored; it can no longer be discarded.
final class SavingMeasurement extends MeasurementState {
  /// Creates the state.
  const SavingMeasurement({required this.at});

  /// Where the point is.
  final SitePoint at;
}

/// What the last point recorded, or that it could not be stored.
sealed class MeasurementOutcome {
  const MeasurementOutcome();
}

/// Stored; [readings] per target.
final class PointSaved extends MeasurementOutcome {
  /// Creates the outcome.
  const PointSaved(this.readings);

  /// One reading per target.
  final List<TargetReading> readings;
}

/// Not stored; the rescuer measures again.
final class PointNotSaved extends MeasurementOutcome {
  /// Creates the outcome.
  const PointNotSaved();
}

/// No Bluetooth device at all was heard during the point: the scan was not working, so the point
/// was thrown away instead of storing a false "not heard".
final class PointRadioSilent extends MeasurementOutcome {
  /// Creates the outcome.
  const PointRadioSilent();
}
