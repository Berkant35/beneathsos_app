import 'dart:math' as math;

import 'package:beneathsos_app/features/probability_map/domain/map_request.dart';
import 'package:locator_engine/locator_engine.dart';
import 'package:rubble_core/rubble_core.dart';

/// Where the phone most likely is, always with its uncertainty (rule 1): the [centre], the radius of
/// the circle around it that holds half the probability, and how far the centre lies in from the
/// nearest side of the rubble — a distance on the drawing, never one read from the signal (rule 2).
typedef LikelySpotResult = ({
  SitePoint centre,
  Meters radius50,
  Meters fromEdge,
});

/// Places measured closer together than this (real metres) cannot tell the map apart.
const minSpreadM = 3.0;

/// The likely spot of [map] inside [outline] (both real metres): the probability-weighted middle of
/// the 50 % area — or its most likely cell when that middle falls outside it (two separate areas: the
/// spot never sits between them).
LikelySpotResult likelySpot(ProbabilityMap map, RubblePolygon outline) {
  final cells = [
    for (var i = 0; i < map.probabilities.length; i++)
      if (map.probabilities[i] > 0) i,
  ];
  var (x, y, mass) = (0.0, 0.0, 0.0);
  var best = cells.first;
  for (final i in cells) {
    final p = map.probabilities[i];
    if (p > map.probabilities[best]) best = i;
    if (map.regionOf(i) != Region.likely50) continue;
    final c = map.centre(i);
    x += p * c.x.value;
    y += p * c.y.value;
    mass += p;
  }
  var centre = SitePoint(Meters(x / mass), Meters(y / mass));
  if (!_inLikely50(map, centre)) centre = map.centre(best);

  final byDistance = [
    for (final i in cells) (map.centre(i).distanceTo(centre).value, i),
  ]..sort((a, b) => a.$1.compareTo(b.$1));
  var held = 0.0;
  var radius = 0.0;
  for (final (d, i) in byDistance) {
    held += map.probabilities[i];
    radius = d;
    if (held >= 0.5) break;
  }
  return (
    centre: centre,
    radius50: Meters(math.max(radius, map.cell.value / 2)),
    fromEdge: Meters(
      outline.edges.map((e) => distanceToSide(centre, e)).reduce(math.min),
    ),
  );
}

/// Whether the places of [observations] (real metres) all lie within [minSpreadM] of each other.
bool bunched(List<Observation> observations) {
  for (final a in observations) {
    for (final b in observations) {
      if (a.at.distanceTo(b.at).value >= minSpreadM) return false;
    }
  }
  return true;
}

bool _inLikely50(ProbabilityMap map, SitePoint at) {
  final col = ((at.x.value - map.origin.x.value) / map.cell.value).floor();
  final row = ((at.y.value - map.origin.y.value) / map.cell.value).floor();
  if (col < 0 || col >= map.cols || row < 0 || row >= map.rows) return false;
  return map.regionOf(row * map.cols + col) == Region.likely50;
}
