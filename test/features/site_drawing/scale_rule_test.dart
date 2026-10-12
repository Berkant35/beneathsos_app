import 'package:beneathsos_app/features/site_drawing/domain/scale_rule.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubble_core/rubble_core.dart';

void main() {
  test('the factor is the real length over the drawn one', () {
    expect(checkRealLength('20', drawn: const Meters(16)), (
      factor: 1.25,
      problem: null,
    ));
  });

  test('a decimal comma is accepted (Turkish keyboards)', () {
    expect(checkRealLength('18,2', drawn: const Meters(18.2)).factor, 1);
  });

  test('empty, not a number, too short or too long are problems', () {
    expect(
      checkRealLength('', drawn: const Meters(10)).problem,
      RealLengthProblem.notANumber,
    );
    expect(
      checkRealLength('abc', drawn: const Meters(10)).problem,
      RealLengthProblem.notANumber,
    );
    expect(
      checkRealLength('0.4', drawn: const Meters(10)).problem,
      RealLengthProblem.outOfRange,
    );
    expect(
      checkRealLength('501', drawn: const Meters(10)).problem,
      RealLengthProblem.outOfRange,
    );
  });

  test('the longest side is the default choice', () {
    final outline = RubblePolygon(const [
      SitePoint(Meters.zero, Meters.zero),
      SitePoint(Meters(10), Meters.zero),
      SitePoint(Meters(10), Meters(4)),
    ]);
    expect(longestSide(outline), 2); // the hypotenuse back to the start
  });
}
