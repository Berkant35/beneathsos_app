import 'dart:isolate';

import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/features/probability_map/domain/map_memo.dart';
import 'package:beneathsos_app/features/probability_map/domain/map_request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rubble_core/rubble_core.dart';

part 'map_providers.g.dart';

/// Runs the engine for one request.
typedef MapEngine = Future<MapResult> Function(MapRequest request);

/// Runs the engine off the UI isolate (CLAUDE.md §4); tests run it in place.
@Riverpod(keepAlive: true)
MapEngine mapEngine(Ref ref) =>
    (request) => Isolate.run(() => computeMap(request));

/// The engine behind a memory of recent runs: an unchanged request is not run again.
@Riverpod(keepAlive: true)
MapMemo mapMemo(Ref ref) => MapMemo(ref.watch(mapEngineProvider));

/// What the map screen shows for one target: the map, whether it rests on too few places with a
/// signal, and how many points on the rubble were left out.
typedef TargetMap = ({MapResult result, bool lowInformation, int onRubble});

/// The probability map of [targetId] in [sessionId]; null until there is an outline and a point.
@riverpod
Future<TargetMap?> probabilityMap(
  Ref ref,
  String sessionId,
  String targetId,
) async {
  final memo = ref.watch(mapMemoProvider);
  final search = await ref.watch(sessionStateProvider(sessionId).future);
  final target = TargetId(targetId);
  final request = requestFor(search, target);
  if (request == null) return null;
  return (
    result: await memo(request),
    lowInformation: isLowInformation(request.observations),
    onRubble: pointsOnRubble(search, target),
  );
}

/// The suggested next point on the drawing, for the first target (the phone searched for), or null
/// while there is no map.
@riverpod
Future<SitePoint?> suggestedPoint(Ref ref, String sessionId) async {
  final search = await ref.watch(sessionStateProvider(sessionId).future);
  final target = search.targets.keys.firstOrNull;
  if (target == null) return null;
  final map = await ref.watch(
    probabilityMapProvider(sessionId, target.value).future,
  );
  final next = map?.result.next;
  return next == null ? null : toDrawn(next, search.scale);
}
