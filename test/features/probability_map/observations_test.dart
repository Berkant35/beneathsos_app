import 'package:beneathsos_app/features/probability_map/domain/map_request.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locator_engine/locator_engine.dart';
import 'package:rubble_core/rubble_core.dart';

SitePoint p(double x, double y) => SitePoint(Meters(x), Meters(y));

void main() {
  const phone = TargetId('t1');
  const watch = TargetId('t2');

  EventEnvelope e(int seq, SessionEvent event) => EventEnvelope(
    id: EventId('e$seq'),
    session: const SessionId('s'),
    seq: seq,
    hlc: HybridTimestamp(
      physicalMs: 1000 + seq,
      counter: 0,
      device: const DeviceId('d'),
    ),
    event: event,
  );

  final events = [
    e(1, const SiteCreated(title: 'Site', engineProfile: 'dense@1')),
    e(2, MeasurementPointPlaced(point: const PointId('a'), at: p(-1, -1))),
    e(
      3,
      MeasurementCompleted(
        point: const PointId('a'),
        duration: const Duration(seconds: 15),
        readings: [
          SignalHeard(phone, median: const Dbm(-84), samples: 20),
          const NoSignal(watch),
        ],
      ),
    ),
    e(4, MeasurementPointPlaced(point: const PointId('b'), at: p(13, -1))),
    e(
      5,
      const MeasurementCompleted(
        point: PointId('b'),
        duration: Duration(seconds: 15),
        readings: [NoSignal(phone), NoSignal(watch)],
      ),
    ),
    // Measured before it was placed (merged logs): no position, left out.
    e(
      6,
      const MeasurementCompleted(
        point: PointId('c'),
        duration: Duration(seconds: 15),
        readings: [NoSignal(phone)],
      ),
    ),
  ];
  final search = SessionProjection.replay(events);
  final outline = e(
    7,
    RubblePolygonSet(RubblePolygon([p(0, 0), p(12, 0), p(12, 10)])),
  );

  test('one observation per measured point of the target, heard or not', () {
    final observations = observationsFor(search, phone);
    expect(observations, hasLength(2));
    expect(
      (observations[0].at, observations[0].median),
      (p(-1, -1), const Dbm(-84)),
    );
    expect((observations[1].at, observations[1].heard), (p(13, -1), false));
  });

  test('other targets are left out', () {
    expect(observationsFor(search, watch).every((o) => !o.heard), isTrue);
  });

  test('low information: fewer than 3 points where the target was heard', () {
    expect(isLowInformation(observationsFor(search, phone)), isTrue);
  });

  test('the profile of the search, the default one for an unknown id', () {
    expect(profileFor(search).id, 'dense@1');
    expect(profileFor(SessionState.empty).id, EngineProfile.voidedPancake.id);
  });

  test('no request without an outline or without a point of the target', () {
    expect(requestFor(search, phone), isNull); // no outline drawn
    final drawn = SessionProjection.replay([...events, outline]);
    expect(requestFor(drawn, const TargetId('other')), isNull);
    expect(requestFor(drawn, phone)!.profileId, 'dense@1');
  });

  test('the engine gets real metres: outline and points times the scale', () {
    final drawn = SessionProjection.replay([
      ...events,
      outline,
      e(8, ScaleSet(factor: 1.5, source: ScaleSource.tape)),
    ]);
    final request = requestFor(drawn, phone)!;
    expect(request.outline.corners, [p(0, 0), p(18, 0), p(18, 15)]);
    expect(request.observations.map((o) => o.at), [
      p(-1.5, -1.5),
      p(19.5, -1.5),
    ]);
    expect(toDrawn(p(18, 15), drawn.scale), p(12, 10));
  });
}
