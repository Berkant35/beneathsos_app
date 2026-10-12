import 'package:beneathsos_app/core/formatting/measures.dart';
import 'package:beneathsos_app/features/probability_map/domain/map_request.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:locator_engine/locator_engine.dart';
import 'package:rubble_canvas/rubble_canvas.dart';
import 'package:rubble_core/rubble_core.dart';

/// The engine's map as canvas layers and words.
mixin MapMixin {
  /// The 50 % / 90 % regions of [map] (real metres) on the drawing, whose lengths are × [scale].
  HeatLayer heatOf(ProbabilityMap map, double scale) => HeatLayer(
    origin: toDrawn(map.origin, scale),
    cell: Meters(map.cell.value / scale),
    cols: map.cols,
    rows: map.rows,
    regions: [
      for (var i = 0; i < map.cols * map.rows; i++)
        switch (map.regionOf(i)) {
          Region.likely50 => HeatRegion.likely50,
          Region.likely90 => HeatRegion.likely90,
          Region.outside => HeatRegion.outside,
        },
    ],
  );

  /// Measured points of [target] (heard / not heard) and the suggested [next] point (real metres).
  List<MapPoint> pointsOf(
    SessionState search,
    TargetId target,
    SitePoint? next,
  ) => [
    for (final point in search.measuredPoints)
      if (point.at case final at?)
        for (final reading in point.readings)
          if (reading.target == target)
            MapPoint(
              at: at,
              kind: reading is SignalHeard
                  ? MapPointKind.heard
                  : MapPointKind.notHeard,
            ),
    if (next != null)
      MapPoint(at: toDrawn(next, search.scale), kind: MapPointKind.suggested),
  ];

  /// "Most likely area: 4.4 m² (50 %) · 14 m² (90 %)" — areas, never a spot (rule 1).
  String areas(AppLocalizations l10n, ProbabilityMap map) => l10n.probAreas(
    squareMetresLabel(l10n, map.area50),
    squareMetresLabel(l10n, map.area90),
  );
}
