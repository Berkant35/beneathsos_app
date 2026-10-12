import 'package:locator_engine/locator_engine.dart';
import 'package:rubble_core/rubble_core.dart';

/// Fewer points than this where the phone was heard: the map is shown with a "low information" badge
/// (edge case 10) — non-detections still shape it.
const minHeardPoints = 3;

/// One observation per measured point of [target]: heard with its median, or not heard (rule 3).
/// Points without a position (measured before they were placed, merged logs) are left out.
List<Observation> observationsFor(SessionState search, TargetId target) => [
  for (final point in search.measuredPoints)
    if (point.at case final at?)
      for (final reading in point.readings)
        if (reading.target == target)
          switch (reading) {
            SignalHeard(:final median) => Observation.heard(at, median),
            NoSignal() => Observation.notHeard(at),
          },
];

/// Whether [observations] heard the phone at fewer than [minHeardPoints] points.
bool isLowInformation(List<Observation> observations) =>
    observations.where((o) => o.heard).length < minHeardPoints;

/// The engine profile of [search] (`SiteCreated.engineProfile`), or voided pancake for an unknown id.
EngineProfile profileFor(SessionState search) =>
    EngineProfile.byId(search.engineProfile ?? '') ??
    EngineProfile.voidedPancake;

/// What the engine needs for one map (sendable to an isolate).
typedef MapRequest = ({
  RubblePolygon outline,
  List<Observation> observations,
  String profileId,
});

/// What the engine needs for the map of [target], or null before there is an outline and a point.
/// The outline and points are drawn lengths; the engine gets real metres (× `ScaleSet`).
MapRequest? requestFor(SessionState search, TargetId target) {
  final outline = search.outline;
  final observations = observationsFor(search, target);
  if (outline == null || observations.isEmpty) return null;
  final scale = search.scale;
  return (
    outline: RubblePolygon([for (final c in outline.corners) _times(c, scale)]),
    observations: [
      for (final o in observations)
        switch (o.median) {
          final median? => Observation.heard(_times(o.at, scale), median),
          null => Observation.notHeard(_times(o.at, scale)),
        },
    ],
    profileId: profileFor(search).id,
  );
}

/// A point of the engine's map (real metres) on the drawing.
SitePoint toDrawn(SitePoint real, double scale) => _times(real, 1 / scale);

SitePoint _times(SitePoint p, double factor) =>
    SitePoint(Meters(p.x.value * factor), Meters(p.y.value * factor));

/// The map (real metres) and the suggested next point (real metres).
typedef MapResult = ({ProbabilityMap map, SitePoint? next});

/// Runs the engine for [request] (pure; heavy — the app runs it in an isolate).
MapResult computeMap(MapRequest request) {
  final profile =
      EngineProfile.byId(request.profileId) ?? EngineProfile.voidedPancake;
  final map = estimate(
    outline: request.outline,
    observations: request.observations,
    profile: profile,
  );
  return (
    map: map,
    next: suggestNextPoint(
      outline: request.outline,
      observations: request.observations,
      map: map,
      profile: profile,
    ),
  );
}
