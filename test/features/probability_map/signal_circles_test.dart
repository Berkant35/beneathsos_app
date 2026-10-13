import 'package:beneathsos_app/features/probability_map/domain/signal_circles.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locator_engine/locator_engine.dart';
import 'package:rubble_core/rubble_core.dart';

SitePoint p(double x, double y) => SitePoint(Meters(x), Meters(y));

void main() {
  final voided = EngineProfile.voidedPancake;

  test('a weaker signal draws a larger circle, through rubble (metres, not free space)', () {
    final near = signalRadius(const Dbm(-70), voided).value;
    final far = signalRadius(const Dbm(-98), voided).value;
    expect(near, lessThan(far));
    // −98 dBm with the profile's middle exponent (2.5) and attenuation (4 dB/m): about 5 m.
    expect(far, closeTo(5.3, 0.3));
    // Dense rubble eats the signal faster: the same reading means a smaller circle.
    expect(
      signalRadius(const Dbm(-98), EngineProfile.dense).value,
      lessThan(far),
    );
  });

  test('a signal stronger than at 0.3 m or weaker than at 60 m is clamped', () {
    expect(signalRadius(const Dbm(-20), voided).value, closeTo(0.3, 1e-9));
    expect(signalRadius(const Dbm(-400), voided).value, closeTo(60, 1e-9));
  });

  final square = RubblePolygon([p(0, -5), p(10, -5), p(10, 5), p(0, 5)]);

  test('circles meet where they agree best, inside the rubble', () {
    final meet = meetingPoint([
      (p(-1, 0), const Meters(6)),
      (p(11, 0), const Meters(6)),
      (p(5, -6), const Meters(6)),
    ], square)!;
    expect(meet.distanceTo(p(5, 0)).value, lessThan(0.5));
    expect(square.contains(meet), isTrue);
  });

  test('even when the circles alone would meet outside, the spot stays in the rubble', () {
    final meet = meetingPoint([
      (p(-1, 0), const Meters(1)),
      (p(-1, 2), const Meters(1)),
    ], square)!;
    expect(square.contains(meet), isTrue);
  });

  test('one circle cannot meet another', () {
    expect(meetingPoint([(p(-1, 0), const Meters(3))], square), isNull);
  });
}
