import 'dart:math' as math;

import 'package:locator_engine/locator_engine.dart';
import 'package:rubble_core/rubble_core.dart';

/// How the map did, once the phone was found: the region of the spot, and how far it lay outside the
/// 90 % area (zero inside). A record for field campaigns, never a claim about a next search.
typedef FoundReport = ({Region region, Meters outside90});

/// The report for a phone found at [found] (real metres) on [map].
FoundReport foundReport(ProbabilityMap map, SitePoint found) {
  final x = found.x.value;
  final y = found.y.value;
  final cell = map.cell.value;
  // A spot on an edge or corner touches up to four cells (map taps snap to 0.5 m, so this is
  // common): it counts in the best region among them.
  var region = Region.outside;
  for (final col in _touching((x - map.origin.x.value) / cell)) {
    for (final row in _touching((y - map.origin.y.value) / cell)) {
      if (col < 0 || col >= map.cols || row < 0 || row >= map.rows) continue;
      final r = map.regionOf(row * map.cols + col);
      if (r.index < region.index) region = r;
    }
  }
  if (region != Region.outside) return (region: region, outside90: Meters.zero);
  var nearest = double.infinity;
  for (var i = 0; i < map.cols * map.rows; i++) {
    if (map.regionOf(i) == Region.outside) continue;
    final x0 = map.origin.x.value + cell * (i % map.cols);
    final y0 = map.origin.y.value + cell * (i ~/ map.cols);
    final dx = math.max(math.max(x0 - x, 0), x - (x0 + cell));
    final dy = math.max(math.max(y0 - y, 0), y - (y0 + cell));
    nearest = math.min(nearest, math.sqrt(dx * dx + dy * dy));
  }
  return (region: Region.outside, outside90: Meters(nearest));
}

/// The cell index of [position] (in cells), and the one before when it lies on their edge.
List<int> _touching(double position) {
  final cell = position.floor();
  final onEdge = (position - position.round()).abs() < 1e-9;
  return onEdge ? [position.round(), position.round() - 1] : [cell];
}
