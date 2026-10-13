import 'package:beneathsos_app/core/models/ble_sample.dart';
import 'package:beneathsos_app/features/measurement/domain/measurement_state.dart';
import 'package:beneathsos_app/features/targets/domain/presence_event.dart';
import 'package:beneathsos_app/features/targets/domain/relink.dart';
import 'package:beneathsos_app/features/targets/domain/rssi_stats.dart';
import 'package:beneathsos_app/features/targets/domain/tracker_snapshot.dart';
import 'package:rubble_core/rubble_core.dart';

/// How a point is measured. The threshold and the reading count match the engine's model (the median
/// of many readings; below −100 dBm a phone counts as not heard).
abstract final class MeasurementPolicy {
  /// Still time needed at a point (the reference simulation averages ~20 readings).
  static const duration = Duration(seconds: 15);

  /// Above this (m/s², gravity removed) the rescuer is moving.
  static const movingAbove = 0.8;

  /// Fewer readings than this are not a reliable median: not heard.
  static const minReadings = 3;

  /// A median below this is not heard (the engine profiles' detection threshold).
  static const heardFrom = Dbm(-100);
}

/// Whether one motion reading (m/s², gravity removed) means the rescuer is moving.
bool isMovement(double magnitude) => magnitude > MeasurementPolicy.movingAbove;

/// One reading per target from the kept readings: the median and count of its identity, or
/// [NoSignal] — a point where the phone was not heard is data (rule 3). Implausible values are
/// dropped; fewer than [MeasurementPolicy.minReadings] or a median below
/// [MeasurementPolicy.heardFrom] counts as not heard.
List<TargetReading> summarizeReadings(
  Map<TargetId, String> targets,
  List<BleSample> kept,
) => [
  for (final MapEntry(key: target, value: key) in targets.entries)
    _reading(target, [
      for (final s in kept)
        if (s.key == key && Dbm(s.rssi.toDouble()).isPlausible) s.rssi,
    ]),
];

TargetReading _reading(TargetId target, List<int> rssi) {
  if (rssi.length < MeasurementPolicy.minReadings) return NoSignal(target);
  final middle = median(rssi)!;
  if (middle < MeasurementPolicy.heardFrom.value) return NoSignal(target);
  return SignalHeard(target, median: Dbm(middle), samples: rssi.length);
}

/// The readings and still time of one point. Readings wait for their second to end: a second with
/// movement, without scanning or in the background neither counts nor keeps its readings.
final class MeasurementWindow {
  /// A window of [duration] still time (Settings; [MeasurementPolicy.duration] by default).
  MeasurementWindow({this.duration = MeasurementPolicy.duration});

  /// Still time needed.
  final Duration duration;

  final _pending = <BleSample>[];
  final _kept = <BleSample>[];
  var _moved = false;
  var _stillSeconds = 0;

  /// Still seconds so far.
  int get stillSeconds => _stillSeconds;

  /// Readings kept (from still seconds only).
  List<BleSample> get kept => List.unmodifiable(_kept);

  /// Still time left.
  Duration get remaining {
    final left = duration - Duration(seconds: _stillSeconds);
    return left.isNegative ? Duration.zero : left;
  }

  /// Enough still time.
  bool get complete => remaining == Duration.zero;

  /// How many kept readings came from [key].
  int count(String key) => _kept.where((s) => s.key == key).length;

  /// Readings arrived.
  void heard(List<BleSample> batch) => _pending.addAll(batch);

  /// A motion reading arrived.
  void felt(double magnitude) {
    if (isMovement(magnitude)) _moved = true;
  }

  /// A second ended. It counts only while [scanning] and in the [foreground] without movement;
  /// returns whether the phone moved during it.
  bool tick({required bool scanning, required bool foreground}) {
    final moved = _moved;
    _moved = false;
    if (scanning && foreground && !moved) {
      _stillSeconds++;
      _kept.addAll(_pending);
    }
    _pending.clear();
    return moved;
  }
}

/// A possible identity change of a target, offered only while the target is silent now, never with
/// a negative gap and never again after the rescuer said No.
RelinkSuggestion? relinkSuggestion(
  Map<TargetId, String> targets,
  TrackerSnapshot heard, {
  required int nowMillis,
  required Set<(String, String)> rejected,
}) {
  final recentlyHeard = {
    for (final d in heard.devices)
      if (nowMillis - d.lastSeenMillis <=
          PresencePolicy.goneAfter.inMilliseconds)
        d.key,
  };
  for (final MapEntry(key: target, value: key) in targets.entries) {
    if (recentlyHeard.contains(key)) continue;
    for (final candidate in suggestRelinks(
      targetKey: key,
      events: heard.events,
    )) {
      final rejectedBefore = rejected.contains((key, candidate.key));
      if (candidate.gapSeconds < 0 || rejectedBefore) continue;
      return (
        target: target,
        from: key,
        to: candidate.key,
        gapSeconds: candidate.gapSeconds,
      );
    }
  }
  return null;
}
