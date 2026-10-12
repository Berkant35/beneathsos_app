import 'package:beneathsos_app/core/models/ble_sample.dart';
import 'package:beneathsos_app/features/targets/domain/rssi_stats.dart';
import 'package:rubble_core/rubble_core.dart';

/// How a point is measured.
abstract final class MeasurementPolicy {
  /// Still time needed at a point (the reference simulation averages ~20 readings).
  static const duration = Duration(seconds: 15);

  /// Above this (m/s², gravity removed) the rescuer is moving.
  static const movingAbove = 0.8;
}

/// One reading per target from the readings heard during the still time: the median and the count of
/// its identity, or [NoSignal] — a point where the phone was not heard is data (rule 3). Values outside
/// what a radio can report are dropped.
List<TargetReading> summarizeReadings(
  Map<TargetId, String> targets,
  List<BleSample> heard,
) => [
  for (final MapEntry(key: target, value: key) in targets.entries)
    _reading(target, [
      for (final s in heard)
        if (s.key == key && Dbm(s.rssi.toDouble()).isPlausible) s.rssi,
    ]),
];

TargetReading _reading(TargetId target, List<int> rssi) => rssi.isEmpty
    ? NoSignal(target)
    : SignalHeard(target, median: Dbm(median(rssi)!), samples: rssi.length);

/// Whether one motion reading (m/s², gravity removed) means the rescuer is moving.
bool isMovement(double magnitude) => magnitude > MeasurementPolicy.movingAbove;
