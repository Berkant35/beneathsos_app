import 'package:beneathsos_app/features/probability_map/domain/depth.dart';
import 'package:beneathsos_app/features/probability_map/domain/map_request.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locator_engine/locator_engine.dart';
import 'package:rubble_core/rubble_core.dart';

SitePoint p(double x, double y) => SitePoint(Meters(x), Meters(y));

void main() {
  final base = EngineProfile.voidedPancake;

  test("the rescuers' depth replaces the profile's guess of where the phone is", () {
    final bottom = withDepth(base, (
      height: const Meters(6),
      level: TrappedLevel.bottom,
    ));
    expect(bottom.rubbleHeightM, 6);
    expect(bottom.victimHeightFractions, levelFractions(TrappedLevel.bottom));
    expect(bottom.id, base.id);
    expect(phoneHeight(bottom).value, closeTo(6 * 0.175, 1e-9));
    // The level not known: the height still counts, the spread of levels stays.
    final unknown = withDepth(base, (
      height: const Meters(9),
      level: TrappedLevel.unknown,
    ));
    expect(unknown.rubbleHeightM, 9);
    expect(unknown.victimHeightFractions, base.victimHeightFractions);
    expect(withDepth(base, null), same(base));
  });

  test('a circle on the map is the slant distance seen from above', () {
    expect(
      horizontalRadius(const Meters(5), const Meters(3)).value,
      closeTo(4, 1e-9),
    );
    // A signal too strong for that depth still draws the smallest circle.
    expect(horizontalRadius(const Meters(2), const Meters(3)).value, 0.3);
  });

  test('the map changes with the depth (the engine gets it)', () {
    final outline = RubblePolygon([p(0, 0), p(12, 0), p(12, 10), p(0, 10)]);
    final observations = [
      Observation.heard(p(-1, -1), const Dbm(-80)),
      Observation.heard(p(13, 11), const Dbm(-92)),
      Observation.notHeard(p(13, -1)),
    ];
    MapResult run(RubbleDepth? depth) => computeMap((
      outline: outline,
      observations: observations,
      profileId: base.id,
      depth: depth,
    ));
    final upper = run((height: const Meters(4), level: TrappedLevel.upper));
    final bottom = run((height: const Meters(4), level: TrappedLevel.bottom));
    expect(upper.map.area50, isNot(bottom.map.area50));
  });
}
