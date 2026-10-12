import 'package:beneathsos_app/features/targets/domain/device_kind.dart';
import 'package:beneathsos_app/features/targets/domain/tracker_snapshot.dart';
import 'package:rubble_core/rubble_core.dart';

/// Which devices heard during the surface scan are phones on the surface (team, bystanders).
abstract final class AmbientPolicy {
  /// How long the surface scan runs.
  static const duration = Duration(seconds: 30);

  /// Heard at least this strongly (median) — near the rescuer standing 10 m from the rubble. Weaker
  /// devices stay candidates: the trapped phone may be heard faintly even from there.
  static const surfaceMedian = Dbm(-80);

  /// Heard at least this often, so one stray reading does not exclude a device.
  static const minSamples = 3;
}

/// Keys of the surface phones among [heard].
List<String> surfacePhones(Iterable<DeviceSummary> heard) => [
  for (final d in heard)
    if (d.sampleCount >= AmbientPolicy.minSamples &&
        d.median != null &&
        d.median!.value >= AmbientPolicy.surfaceMedian.value)
      d.key,
];

/// How strong a candidate's signal is (never turned into a distance — rule 2).
enum SignalStrength {
  /// Below −75 dBm.
  weak,

  /// Between.
  medium,

  /// −55 dBm or stronger: probably right next to the rescuer.
  veryStrong,
}

/// Thresholds of the candidate ranking.
abstract final class CandidatePolicy {
  /// Still when the spread stays within this.
  static const maxStillSpread = Decibels(4);

  /// Still needs at least this many readings.
  static const minStillSamples = 5;

  /// Weaker than this is weak.
  static const weakBelow = Dbm(-75);

  /// This strong or stronger is very strong.
  static const veryStrongFrom = Dbm(-55);
}

/// A device that could be the trapped phone, with the facts behind its rank.
final class TargetCandidate {
  /// Creates a candidate.
  const TargetCandidate({
    required this.device,
    required this.still,
    required this.strength,
  });

  /// The device.
  final DeviceSummary device;

  /// Its signal hardly changes (a buried phone does not move).
  final bool still;

  /// How strong its signal is.
  final SignalStrength strength;

  int get _score =>
      (device.kind == DeviceKind.appleFindMy ? 3 : 0) +
      (still ? 2 : 0) +
      switch (strength) {
        SignalStrength.weak => 1,
        SignalStrength.medium => 0,
        SignalStrength.veryStrong => -2,
      };
}

/// Devices heard now that may be the trapped phone, most promising first: not [surface] phones, not
/// already [targets].
List<TargetCandidate> rankCandidates(
  Iterable<DeviceSummary> devices, {
  required Set<String> surface,
  required Set<String> targets,
}) {
  final candidates = [
    for (final d in devices)
      if (!surface.contains(d.key) && !targets.contains(d.key))
        TargetCandidate(
          device: d,
          still:
              d.sampleCount >= CandidatePolicy.minStillSamples &&
              d.spread != null &&
              d.spread!.value <= CandidatePolicy.maxStillSpread.value,
          strength: _strength(d.median ?? Dbm(d.lastRssi.toDouble())),
        ),
  ];
  // Stable: equal scores keep the tracker's order (first heard first).
  final indexed = candidates.indexed.toList()
    ..sort((a, b) {
      final byScore = b.$2._score.compareTo(a.$2._score);
      return byScore != 0 ? byScore : a.$1.compareTo(b.$1);
    });
  return [for (final (_, c) in indexed) c];
}

SignalStrength _strength(Dbm median) {
  if (median.value < CandidatePolicy.weakBelow.value) {
    return SignalStrength.weak;
  }
  if (median.value >= CandidatePolicy.veryStrongFrom.value) {
    return SignalStrength.veryStrong;
  }
  return SignalStrength.medium;
}
