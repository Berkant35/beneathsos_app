import 'package:beneathsos_app/features/targets/domain/presence_event.dart';

/// A candidate new identity for a target that stopped advertising.
final class RelinkCandidate {
  /// Creates a candidate.
  const RelinkCandidate({
    required this.key,
    required this.gapSeconds,
    required this.rssiDelta,
  });

  /// New identity.
  final String key;

  /// Seconds between the target disappearing and the candidate appearing (may be negative).
  final int gapSeconds;

  /// Absolute RSSI difference between the target's last and the candidate's first reading.
  final int rssiDelta;
}

/// Rules for proposing a relink after address rotation.
abstract final class RelinkPolicy {
  /// Max time between "gone" and "appeared".
  static const maxGap = Duration(seconds: 30);

  /// Max RSSI difference in dB.
  static const maxRssiDelta = 8;
}

/// Suggests identities that likely are the target after it rotated its address.
/// Pure function; ordered by best match first.
List<RelinkCandidate> suggestRelinks({
  required String targetKey,
  required List<PresenceEvent> events,
}) {
  final gone = events.lastWhereOrNull(
    (e) => e.key == targetKey && e.change == PresenceChange.gone,
  );
  if (gone == null) return const [];
  final lastSeen = gone.atMillis - PresencePolicy.goneAfter.inMilliseconds;
  final candidates =
      <RelinkCandidate>[
        for (final e in events)
          if (e.change == PresenceChange.appeared && e.key != targetKey)
            if ((e.atMillis - lastSeen).abs() <=
                RelinkPolicy.maxGap.inMilliseconds)
              if ((e.rssi - gone.rssi).abs() <= RelinkPolicy.maxRssiDelta)
                RelinkCandidate(
                  key: e.key,
                  gapSeconds: (e.atMillis - lastSeen) ~/ 1000,
                  rssiDelta: (e.rssi - gone.rssi).abs(),
                ),
      ]..sort(
        (a, b) => (a.rssiDelta + a.gapSeconds.abs()).compareTo(
          b.rssiDelta + b.gapSeconds.abs(),
        ),
      );
  return candidates;
}

extension on List<PresenceEvent> {
  PresenceEvent? lastWhereOrNull(bool Function(PresenceEvent) test) {
    for (var i = length - 1; i >= 0; i--) {
      if (test(this[i])) return this[i];
    }
    return null;
  }
}
