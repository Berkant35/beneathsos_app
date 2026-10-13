import 'dart:typed_data';

import 'package:beneathsos_app/features/probability_map/presentation/mixins/map_mixin.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locator_engine/locator_engine.dart';
import 'package:rubble_canvas/rubble_canvas.dart';
import 'package:rubble_core/rubble_core.dart';

SitePoint p(double x, double y) => SitePoint(Meters(x), Meters(y));

class _Subject with MapMixin {}

void main() {
  final subject = _Subject();
  // Real metres: a 3 × 1 grid of 0.5 m cells from (-1, -1).
  final map = ProbabilityMap(
    origin: p(-1, -1),
    cell: const Meters(0.5),
    cols: 3,
    rows: 1,
    probabilities: Float64List.fromList([0.6, 0.3, 0.1]),
    regions: Uint8List.fromList([2, 1, 0]),
  );

  test('the regions are drawn on the drawing (real metres ÷ scale)', () {
    final heat = subject.heatOf(map, 2);
    expect(
      (heat.origin, heat.cell, heat.cols, heat.rows),
      (p(-0.5, -0.5), const Meters(0.25), 3, 1),
    );
    expect(
      [for (var i = 0; i < 3; i++) heat.regionOf(i)],
      [HeatRegion.likely50, HeatRegion.likely90, HeatRegion.outside],
    );
  });

  test('the suggested point is drawn on the drawing too', () {
    final points = subject.pointsOf(
      SessionProjection.replay([
        EventEnvelope(
          id: const EventId('e1'),
          session: const SessionId('s'),
          seq: 1,
          hlc: const HybridTimestamp(
            physicalMs: 1,
            counter: 0,
            device: DeviceId('d'),
          ),
          event: ScaleSet(factor: 2, source: ScaleSource.tape),
        ),
      ]),
      const TargetId('t'),
      p(4, 2),
    );
    expect(points.single.at, p(2, 1));
    expect(points.single.kind, MapPointKind.suggested);
  });

  test(
    'the found line uses real metres and says how many points the map rests on',
    () {
      final l10n = lookupAppLocalizations(const Locale('en'));
      final search = SessionProjection.replay([
        for (final (i, event) in <SessionEvent>[
          ScaleSet(factor: 2, source: ScaleSource.tape),
          MeasurementPointPlaced(point: const PointId('a'), at: p(-3, -3)),
          MeasurementCompleted(
            point: const PointId('a'),
            duration: const Duration(seconds: 15),
            readings: [
              SignalHeard(
                const TargetId('t'),
                median: const Dbm(-80),
                samples: 9,
              ),
            ],
          ),
          // Drawn (−0.25, −0.25) is real (−0.5, −0.5): the 50 % cell of [map].
          GroundTruthRecorded(target: const TargetId('t'), at: p(-0.25, -0.25)),
        ].indexed)
          EventEnvelope(
            id: EventId('e$i'),
            session: const SessionId('s'),
            seq: i,
            hlc: HybridTimestamp(
              physicalMs: 1 + i,
              counter: 0,
              device: const DeviceId('d'),
            ),
            event: event,
          ),
      ]);
      expect(
        subject.foundLine(l10n, search, const TargetId('t'), map),
        'Found inside the 50 % area. 1 point measured · 1 with a signal',
      );
    },
  );
}
