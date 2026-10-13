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
    // A phone that says it is trapped is never a surface phone.
    if (d.kind != DeviceKind.trappedBeacon &&
        d.sampleCount >= AmbientPolicy.minSamples &&
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

  /// Still (or changing) needs at least this many readings in the last 30 s.
  static const minStillSamples = 5;

  /// Weaker than this is weak.
  static const weakBelow = Dbm(-75);

  /// This strong or stronger is very strong.
  static const veryStrongFrom = Dbm(-55);
}

/// What the signal of a device says about movement.
enum Movement {
  /// Steady: it does not move (a buried phone does not).
  still,

  /// Changing a lot: it may be moving (or the rescuer is).
  changing,

  /// Too few recent readings to tell — common for a faint, buried phone; never called "moving".
  notKnownYet,
}

/// A device that could be the trapped phone, with the facts behind its rank.
final class TargetCandidate {
  /// Creates a candidate.
  const TargetCandidate({
    required this.device,
    required this.movement,
    required this.strength,
  });

  /// The device.
  final DeviceSummary device;

  /// What its signal says about movement.
  final Movement movement;

  /// How strong its signal is.
  final SignalStrength strength;

  int get _score =>
      switch (device.kind) {
        DeviceKind.trappedBeacon => 10, // it says so itself: always first
        DeviceKind.appleFindMy => 3,
        _ => 0,
      } +
      switch (movement) {
        Movement.still => 2,
        Movement.notKnownYet => 1, // a faint phone heard rarely must not sink
        Movement.changing => 0,
      } +
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
          movement: _movement(d),
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

Movement _movement(DeviceSummary d) {
  final spread = d.spread;
  if (d.recentCount < CandidatePolicy.minStillSamples || spread == null) {
    return Movement.notKnownYet;
  }
  return spread.value <= CandidatePolicy.maxStillSpread.value
      ? Movement.still
      : Movement.changing;
}

/// [ranked] in the order already shown ([shown] keys, gone ones dropped), new devices last — so cards
/// never move under the rescuer's finger. Ranking again is the rescuer's choice ("Sort again").
List<TargetCandidate> keepOrder(
  List<String> shown,
  List<TargetCandidate> ranked,
) {
  final byKey = {for (final c in ranked) c.device.key: c};
  return [for (final key in shown) ?byKey.remove(key), ...byKey.values];
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
