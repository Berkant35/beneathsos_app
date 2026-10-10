import 'package:beneathsos_app/features/targets/domain/rssi_stats.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('median of odd and even lists', () {
    expect(median([-70, -60, -80]), -70);
    expect(median([-70, -60, -80, -90]), -75);
    expect(median([]), isNull);
  });

  test('standard deviation needs two values', () {
    expect(standardDeviation([-70]), isNull);
    expect(standardDeviation([-70, -70, -70]), 0);
    expect(standardDeviation([-60, -80]), closeTo(14.142, 0.001));
  });
}
