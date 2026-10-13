import 'dart:math' as math;

import 'package:locator_engine/locator_engine.dart';
import 'package:rubble_core/rubble_core.dart';

/// Smallest and largest circle drawn (metres).
const _minRadius = 0.3;
const _maxRadius = 60.0;

/// A rough guide (maintainer's decision, 2026-10-13, ADR 0019): the distance at which a signal crossing
/// the [profile]'s typical rubble all the way — its middle path-loss exponent and attenuation — would
/// arrive as [median]. Free space would draw circles 3–4 times too large; the real distance can still
/// be shorter or longer by metres, so the probability map stays the answer.
Meters signalRadius(Dbm median, EngineProfile profile) {
  final exponent = _middle(profile.pathLossExponents);
  final alpha = _middle(profile.attenuationDbPerM);
  double expected(double r) =>
      profile.txPowerAt1mDbm -
      10 * exponent * math.log(r) / math.ln10 -
      alpha * r;
  if (median.value >= expected(_minRadius)) return const Meters(_minRadius);
  if (median.value <= expected(_maxRadius)) return const Meters(_maxRadius);
  var (lo, hi) = (_minRadius, _maxRadius);
  for (var i = 0; i < 60; i++) {
    final mid = (lo + hi) / 2;
    if (expected(mid) > median.value) {
      lo = mid;
    } else {
      hi = mid;
    }
  }
  return Meters((lo + hi) / 2);
}

/// Where [circles] (centre, radius) agree best inside [outline]: the spot on a [step] grid inside the
/// rubble with the least Σ (distance − radius)²; null with fewer than two circles.
SitePoint? meetingPoint(
  List<(SitePoint, Meters)> circles,
  RubblePolygon outline, {
  double step = 0.25,
}) {
  if (circles.length < 2) return null;
  final bounds = outline.bounds;
  SitePoint? best;
  var bestCost = double.infinity;
  for (
    var x = bounds.min.x.value + step / 2;
    x < bounds.max.x.value;
    x += step
  ) {
    for (
      var y = bounds.min.y.value + step / 2;
      y < bounds.max.y.value;
      y += step
    ) {
      final at = SitePoint(Meters(x), Meters(y));
      if (!outline.contains(at)) continue;
      var cost = 0.0;
      for (final (centre, radius) in circles) {
        final miss = at.distanceTo(centre).value - radius.value;
        cost += miss * miss;
      }
      if (cost < bestCost) {
        bestCost = cost;
        best = at;
      }
    }
  }
  return best;
}

double _middle(List<double> values) => values[values.length ~/ 2];
