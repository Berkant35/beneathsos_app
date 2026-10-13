import 'dart:typed_data';

import 'package:beneathsos_app/features/research/domain/found_report.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locator_engine/locator_engine.dart';
import 'package:rubble_core/rubble_core.dart';

SitePoint p(double x, double y) => SitePoint(Meters(x), Meters(y));

void main() {
  // 4 × 1 cells of 1 m from (0, 0): 50 %, 90 %, outside, outside.
  final map = ProbabilityMap(
    origin: p(0, 0),
    cell: const Meters(1),
    cols: 4,
    rows: 1,
    probabilities: Float64List.fromList([0.6, 0.35, 0.05, 0]),
    regions: Uint8List.fromList([2, 1, 0, 0]),
  );

  test('found inside the 50 % area', () {
    final report = foundReport(map, p(0.5, 0.5));
    expect(report.region, Region.likely50);
    expect(report.outside90, Meters.zero);
  });

  test('found inside the 90 % area', () {
    expect(foundReport(map, p(1.2, 0.9)).region, Region.likely90);
  });

  test('found outside: how far from the 90 % area', () {
    final report = foundReport(map, p(3.5, 0.5));
    expect(report.region, Region.outside);
    expect(report.outside90.value, closeTo(1.5, 1e-9));
    // Off the grid altogether.
    expect(foundReport(map, p(-3, 0.5)).outside90.value, closeTo(3, 1e-9));
  });
}
