import 'package:beneathsos_app/core/beacon/domain/barometric_depth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubble_core/rubble_core.dart';

void main() {
  test(
    'higher pressure at the phone means it is below: about 8.3 m per hPa',
    () {
      final reading = barometricDepth(const Hpa(1013.9), const Hpa(1013.2));
      expect(reading.below.value, closeTo(5.81, 0.01));
      expect(reading.depthClass, BarometricDepth.below);
    },
  );

  test(
    'coarse classes, because two phones\' barometers differ by up to ±1 hPa',
    () {
      BarometricDepth of(double phone) =>
          barometricDepth(Hpa(phone), const Hpa(1000)).depthClass;
      expect(of(999.0), BarometricDepth.above); // 8.3 m above
      expect(of(1000.3), BarometricDepth.level); // 2.5 m
      expect(of(1001), BarometricDepth.below); // 8.3 m
      expect(of(1002), BarometricDepth.deep); // 16.6 m
    },
  );
}
