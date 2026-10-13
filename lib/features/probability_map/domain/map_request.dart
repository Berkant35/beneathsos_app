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

/// Whether [observations] (one per place) heard the phone at fewer than [minHeardPoints] places.
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

/// Places closer than this (real metres) are one place: measuring again where you stand adds no
/// independent information (the slow fading there stays the same).
const samePlaceM = 1.0;

/// A point at least this far inside the outline (real metres) stands on the rubble; nearer is the
/// foot of a wall. The engine models points on the ground around the rubble only.
const onRubbleFromM = 0.5;

/// What the engine needs for the map of [target], or null before there is an outline and a point
/// around the rubble. The outline and points are drawn lengths; the engine gets real metres
/// (× `ScaleSet`), points on the rubble left out and readings at one place merged.
MapRequest? requestFor(SessionState search, TargetId target) {
  final outline = realOutline(search);
  if (outline == null) return null;
  final around = [
    for (final o in _realObservations(search, target))
      if (!_onRubble(outline, o.at)) o,
  ];
  if (around.isEmpty) return null;
  return (
    outline: outline,
    observations: _places(around),
    profileId: profileFor(search).id,
  );
}

/// How many measured points of [target] stand on the rubble (left out of the map).
int pointsOnRubble(SessionState search, TargetId target) {
  final outline = realOutline(search);
  if (outline == null) return 0;
  return _realObservations(
    search,
    target,
  ).where((o) => _onRubble(outline, o.at)).length;
}

/// The outline of [search] in real metres (× `ScaleSet`), or null before it is drawn.
RubblePolygon? realOutline(SessionState search) => switch (search.outline) {
  final outline? => RubblePolygon([
    for (final c in outline.corners) toReal(c, search.scale),
  ]),
  null => null,
};

List<Observation> _realObservations(SessionState search, TargetId target) => [
  for (final o in observationsFor(search, target))
    switch (o.median) {
      final median? => Observation.heard(toReal(o.at, search.scale), median),
      null => Observation.notHeard(toReal(o.at, search.scale)),
    },
];

bool _onRubble(RubblePolygon outline, SitePoint at) =>
    outline.contains(at) &&
    outline.edges.every((e) => distanceToSide(at, e) >= onRubbleFromM);

/// The distance from [q] to the side [e] (real metres when both are).
double distanceToSide(SitePoint q, PolygonEdge e) {
  final (ax, ay) = (e.start.x.value, e.start.y.value);
  final (abx, aby) = (e.end.x.value - ax, e.end.y.value - ay);
  final t =
      (((q.x.value - ax) * abx + (q.y.value - ay) * aby) /
              (abx * abx + aby * aby))
          .clamp(0.0, 1.0);
  return SitePoint(
    Meters(ax + t * abx),
    Meters(ay + t * aby),
  ).distanceTo(q).value;
}

/// One observation per place (the first point within [samePlaceM]): heard when most of its readings
/// heard the phone (a tie counts as heard), with the median of the heard medians.
List<Observation> _places(List<Observation> observations) {
  final places = <List<Observation>>[];
  for (final o in observations) {
    final place = places
        .where((p) => p.first.at.distanceTo(o.at).value < samePlaceM)
        .firstOrNull;
    if (place == null) {
      places.add([o]);
    } else {
      place.add(o);
    }
  }
  return [for (final place in places) _merge(place)];
}

Observation _merge(List<Observation> readings) {
  final heard = [
    for (final r in readings)
      if (r.median case final median?) median.value,
  ]..sort();
  final at = readings.first.at;
  if (heard.length * 2 < readings.length) return Observation.notHeard(at);
  final middle = heard.length ~/ 2;
  return Observation.heard(
    at,
    Dbm(
      heard.length.isOdd
          ? heard[middle]
          : (heard[middle - 1] + heard[middle]) / 2,
    ),
  );
}

/// A point of the engine's map (real metres) on the drawing.
SitePoint toDrawn(SitePoint real, double scale) => toReal(real, 1 / scale);

/// [p] with every length × [factor] (drawn → real with the scale).
SitePoint toReal(SitePoint p, double factor) =>
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
