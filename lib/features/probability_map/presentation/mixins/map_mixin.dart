import 'package:beneathsos_app/core/formatting/levels.dart';
import 'package:beneathsos_app/core/formatting/measures.dart';
import 'package:beneathsos_app/features/probability_map/domain/likely_spot.dart';
import 'package:beneathsos_app/features/probability_map/domain/map_request.dart';
import 'package:beneathsos_app/features/research/domain/found_report.dart';
import 'package:beneathsos_app/features/research/presentation/providers/research_providers.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/painting.dart';
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
  /// [colors] gives a point the colour of its signal circle; [nextLabel] names the suggestion so it
  /// is never read as the phone.
  List<MapPoint> pointsOf(
    SessionState search,
    TargetId target,
    SitePoint? next, {
    Map<PointId, Color> colors = const {},
    String? nextLabel,
  }) => [
    for (final point in search.measuredPoints)
      if (point.at case final at?)
        for (final reading in point.readings)
          if (reading.target == target)
            switch (reading) {
              SignalHeard(:final median) => MapPoint(
                at: at,
                kind: MapPointKind.heard,
                label: median.value.round().toString().replaceFirst('-', '−'),
                strength: ((median.value + 100) / 40).clamp(0.0, 1.0),
                color: colors[point.id],
              ),
              NoSignal() => MapPoint(at: at, kind: MapPointKind.notHeard),
            },
    if (search.groundTruths[target] case final found?)
      MapPoint(at: found, kind: MapPointKind.found),
    if (next != null)
      MapPoint(
        at: toDrawn(next, search.scale),
        kind: MapPointKind.suggested,
        label: nextLabel,
      ),
  ];

  /// "Most likely area: 4.4 m² (50 %) · 14 m² (90 %)" — areas, never a spot (rule 1).
  String areas(AppLocalizations l10n, ProbabilityMap map) => l10n.probAreas(
    squareMetresLabel(l10n, map.area50),
    squareMetresLabel(l10n, map.area90),
  );

  /// How the map did for [target], once its phone was recorded as found; null before.
  String? foundLine(
    AppLocalizations l10n,
    SessionState search,
    TargetId target,
    ProbabilityMap map,
  ) {
    final found = search.groundTruths[target];
    if (found == null) return null;
    final real = SitePoint(
      Meters(found.x.value * search.scale),
      Meters(found.y.value * search.scale),
    );
    final report = foundReport(map, real);
    final measured = search.measuredPoints;
    final basis = l10n.pointSummary(
      measured.length,
      measured.where((p) => p.readings.any((r) => r is SignalHeard)).length,
    );
    final verdict = switch (report.region) {
      Region.likely50 => l10n.probFound50,
      Region.likely90 => l10n.probFound90,
      Region.outside => l10n.probFoundOutside(
        metresLabel(l10n, report.outside90),
      ),
    };
    return '$verdict $basis';
  }

  /// The research line under the map: how to record, a failure, or how the map did.
  String? foundNote(
    AppLocalizations l10n,
    FoundStep step,
    SessionState search,
    TargetId target,
    ProbabilityMap map,
  ) => switch (step) {
    FoundChoosing() => l10n.probTapFound,
    FoundFailed() => l10n.probRecordFailed,
    FoundIdle() || FoundSaving() => foundLine(l10n, search, target, map),
  };

  /// The likely spot on the drawing (the engine works in real metres).
  LikelySpot likelyOf(LikelySpotResult spot, double scale) => (
    centre: toDrawn(spot.centre, scale),
    radius: Meters(spot.radius50.value / scale),
  );

  /// "Most likely spot: inside the dashed circle (…; radius 0.8 m), 1.4 m in from the nearest edge…"
  String spotLine(AppLocalizations l10n, LikelySpotResult spot) =>
      l10n.probSpot(
        metresLabel(l10n, spot.radius50),
        metresLabel(l10n, spot.fromEdge),
      );

  /// "Depth: 6.0 m of rubble · Ground floor (bottom)." — or that none was given (4 m assumed).
  String depthLine(
    AppLocalizations l10n,
    RubbleDepth? depth,
    Meters defaultHeight,
  ) => switch (depth) {
    final depth? => l10n.probDepth(
      metresLabel(l10n, depth.height),
      levelLabel(l10n, depth.level),
    ),
    null => l10n.probDepthUnset(metresLabel(l10n, defaultHeight)),
  };
}
