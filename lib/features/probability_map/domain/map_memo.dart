import 'dart:async';

import 'package:beneathsos_app/features/probability_map/domain/map_request.dart';

/// Remembers the last few engine runs by what the engine sees, so an event that does not change the
/// outline or the observations (placing a point, a relink, switching back to a target) costs no new
/// run — an isolate cannot be cancelled, and a phone's battery matters on site. A failed run is
/// forgotten, so the next request tries again.
final class MapMemo {
  /// Remembers up to [capacity] results of [_run].
  MapMemo(this._run, {this.capacity = 8});

  final Future<MapResult> Function(MapRequest request) _run;

  /// How many results are kept (least recently used dropped first).
  final int capacity;

  /// In order of use (a map literal keeps insertion order).
  final _results = <String, Future<MapResult>>{};

  /// The result for [request], run only when no equal request was seen.
  Future<MapResult> call(MapRequest request) {
    final key = _keyOf(request);
    final known = _results.remove(key);
    if (known != null) return _results[key] = known;
    final run = _run(request);
    _results[key] = run;
    // Dropping an entry only forgets it; a run still going finishes for its caller.
    if (_results.length > capacity) {
      unawaited(_results.remove(_results.keys.first));
    }
    unawaited(
      run.then<void>(
        (_) {},
        onError: (Object _) {
          if (identical(_results[key], run)) unawaited(_results.remove(key));
        },
      ),
    );
    return run;
  }

  static String _keyOf(MapRequest r) => [
    r.profileId,
    '${r.depth?.height.value},${r.depth?.level.name}',
    for (final c in r.outline.corners) '${c.x.value},${c.y.value}',
    '|',
    for (final o in r.observations)
      '${o.at.x.value},${o.at.y.value},${o.median?.value}',
  ].join(';');
}
