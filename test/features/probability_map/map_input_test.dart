import 'dart:typed_data';

import 'package:beneathsos_app/features/probability_map/domain/map_memo.dart';
import 'package:beneathsos_app/features/probability_map/domain/map_request.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locator_engine/locator_engine.dart';
import 'package:rubble_core/rubble_core.dart';

SitePoint p(double x, double y) => SitePoint(Meters(x), Meters(y));

const _phone = TargetId('t1');
var _seq = 0;

EventEnvelope _e(SessionEvent event) => EventEnvelope(
  id: EventId('e${++_seq}'),
  session: const SessionId('s'),
  seq: _seq,
  hlc: HybridTimestamp(
    physicalMs: 1000 + _seq,
    counter: 0,
    device: const DeviceId('d'),
  ),
  event: event,
);

/// A 12 × 10 m search with one point per (position, median or null = not heard).
SessionState _search(List<(SitePoint, double?)> points, {double scale = 1}) {
  _seq = 0;
  return SessionProjection.replay([
    _e(const SiteCreated(title: 'Site', engineProfile: 'voided_pancake@1')),
    _e(
      RubblePolygonSet(RubblePolygon([p(0, 0), p(12, 0), p(12, 10), p(0, 10)])),
    ),
    if (scale != 1) _e(ScaleSet(factor: scale, source: ScaleSource.tape)),
    for (final (i, (at, median)) in points.indexed) ...[
      _e(MeasurementPointPlaced(point: PointId('p$i'), at: at)),
      _e(
        MeasurementCompleted(
          point: PointId('p$i'),
          duration: const Duration(seconds: 15),
          readings: [
            if (median == null)
              const NoSignal(_phone)
            else
              SignalHeard(_phone, median: Dbm(median), samples: 20),
          ],
        ),
      ),
    ],
  ]);
}

void main() {
  test('the same spot measured three times is one place, not three', () {
    final search = _search([
      (p(-1, -1), -85),
      (p(-1, -1), -83),
      (p(-1.5, -1), -90),
      (p(13, 11), null),
    ]);
    final request = requestFor(search, _phone)!;
    expect(request.observations, hasLength(2));
    expect(request.observations.first.at, p(-1, -1));
    expect(request.observations.first.median, const Dbm(-85));
    // One place with a signal: still low information.
    expect(isLowInformation(request.observations), isTrue);
  });

  test('a place is heard when most of its readings heard the phone', () {
    final mostlySilent = requestFor(
      _search([(p(-1, -1), -95), (p(-1, -1), null), (p(-1, -1), null)]),
      _phone,
    )!;
    expect(mostlySilent.observations.single.heard, isFalse);
    final tie = requestFor(
      _search([(p(-1, -1), -95), (p(-1, -1), null)]),
      _phone,
    )!;
    expect(tie.observations.single.median, const Dbm(-95));
  });

  test('places are told apart in real metres', () {
    // 0.75 m apart on the drawing, 1.5 m in reality.
    final request = requestFor(
      _search([(p(-1, -1), -85), (p(-1.75, -1), -86)], scale: 2),
      _phone,
    )!;
    expect(request.observations, hasLength(2));
  });

  test('points on the rubble are left out of the map and counted', () {
    final search = _search([
      (p(6, 5), -70), // on top of the rubble
      (p(0.25, 5), -80), // at the foot of a wall: on the ground
      (p(-1, -1), null),
    ]);
    expect(pointsOnRubble(search, _phone), 1);
    expect(requestFor(search, _phone)!.observations.map((o) => o.at), [
      p(0.25, 5),
      p(-1, -1),
    ]);
    expect(requestFor(_search([(p(6, 5), -70)]), _phone), isNull);
  });

  group('MapMemo', () {
    MapResult result() => (
      map: ProbabilityMap(
        origin: p(0, 0),
        cell: const Meters(1),
        cols: 1,
        rows: 1,
        probabilities: Float64List.fromList([1]),
        regions: Uint8List.fromList([2]),
      ),
      next: null,
    );

    test('an unchanged request is not run again; another one is', () async {
      var runs = 0;
      final memo = MapMemo((request) async {
        runs++;
        return result();
      });
      final search = _search([(p(-1, -1), -85)]);
      await memo(requestFor(search, _phone)!);
      // A new event that does not change what the engine sees (a fresh replay, equal values).
      await memo(requestFor(_search([(p(-1, -1), -85)]), _phone)!);
      expect(runs, 1);
      await memo(requestFor(_search([(p(-1, -1), -80)]), _phone)!);
      expect(runs, 2);
      // Back to the first (e.g. the other target's tab): still known.
      await memo(requestFor(search, _phone)!);
      expect(runs, 2);
    });

    test('a failed run is tried again next time', () async {
      var runs = 0;
      final memo = MapMemo((request) async {
        if (++runs == 1) throw StateError('engine');
        return result();
      });
      final request = requestFor(_search([(p(-1, -1), -85)]), _phone)!;
      await expectLater(memo(request), throwsStateError);
      await memo(request);
      expect(runs, 2);
    });
  });
}
