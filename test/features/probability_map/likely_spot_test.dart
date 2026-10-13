import 'dart:math' as math;
import 'dart:typed_data';

import 'package:beneathsos_app/features/probability_map/domain/likely_spot.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locator_engine/locator_engine.dart';
import 'package:rubble_core/rubble_core.dart';

SitePoint p(double x, double y) => SitePoint(Meters(x), Meters(y));

/// A 10 × 10 grid of 1 m cells from (0, 0) with probability ∝ the sum of Gaussian [blobs].
ProbabilityMap _map(List<(double, double)> blobs) {
  final probabilities = Float64List(100);
  for (var i = 0; i < 100; i++) {
    final (x, y) = (i % 10 + 0.5, i ~/ 10 + 0.5);
    for (final (bx, by) in blobs) {
      final d2 = (x - bx) * (x - bx) + (y - by) * (y - by);
      probabilities[i] += math.exp(-d2 / 2);
    }
  }
  final sum = probabilities.fold(0.0, (a, b) => a + b);
  for (var i = 0; i < 100; i++) {
    probabilities[i] /= sum;
  }
  final order = [for (var i = 0; i < 100; i++) i]
    ..sort((a, b) => probabilities[b].compareTo(probabilities[a]));
  final regions = Uint8List(100);
  var cumulative = 0.0;
  for (final i in order) {
    if (cumulative >= 0.9) break;
    regions[i] = cumulative < 0.5 ? 2 : 1;
    cumulative += probabilities[i];
  }
  return ProbabilityMap(
    origin: p(0, 0),
    cell: const Meters(1),
    cols: 10,
    rows: 10,
    probabilities: probabilities,
    regions: regions,
  );
}

final _outline = RubblePolygon([p(0, 0), p(10, 0), p(10, 10), p(0, 10)]);

void main() {
  test('one likely place: the spot is its middle, and the circle holds half the probability', () {
    final map = _map([(3, 4)]);
    final spot = likelySpot(map, _outline);
    expect(spot.centre.distanceTo(p(3, 4)).value, lessThan(0.6));
    var inside = 0.0;
    for (var i = 0; i < 100; i++) {
      if (map.centre(i).distanceTo(spot.centre).value <= spot.radius50.value) {
        inside += map.probabilities[i];
      }
    }
    expect(inside, greaterThanOrEqualTo(0.5));
    expect(spot.radius50.value, lessThan(2.5));
    expect(spot.fromEdge.value, closeTo(3, 0.6));
  });

  test(
    'two likely places: the spot sits on the stronger one, never between them',
    () {
      final spot = likelySpot(_map([(2, 2), (2, 2), (8, 8)]), _outline);
      expect(spot.centre.distanceTo(p(2, 2)).value, lessThan(1));
    },
  );

  test('points measured close together are flagged', () {
    expect(bunched([Observation.heard(p(-1, -1), const Dbm(-70))]), isTrue);
    expect(
      bunched([
        Observation.heard(p(-1, -1), const Dbm(-70)),
        Observation.notHeard(p(0.5, -1)),
      ]),
      isTrue,
    );
    expect(
      bunched([
        Observation.heard(p(-1, -1), const Dbm(-70)),
        Observation.notHeard(p(11, -1)),
      ]),
      isFalse,
    );
  });
}
