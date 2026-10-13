import 'package:beneathsos_app/core/models/ble_sample.dart';
import 'package:beneathsos_app/features/targets/domain/candidates.dart';
import 'package:beneathsos_app/features/targets/domain/device_kind.dart';
import 'package:beneathsos_app/features/targets/domain/device_tracker.dart';
import 'package:beneathsos_app/features/targets/domain/tracker_snapshot.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubble_core/rubble_core.dart';

DeviceSummary device(
  String key, {
  DeviceKind kind = DeviceKind.other,
  double? median,
  double? spread,
  int samples = 10,
  int? recent,
}) => DeviceSummary(
  key: key,
  kind: kind,
  lastRssi: median?.round() ?? -90,
  firstSeenMillis: 0,
  lastSeenMillis: 30000,
  sampleCount: samples,
  median: median == null ? null : Dbm(median),
  spread: spread == null ? null : Decibels(spread),
  recentCount: recent ?? samples,
);

void main() {
  group('the tracker summarises the last 30 s', () {
    test('median and spread of the recent readings', () {
      final tracker = DeviceTracker()
        ..ingest([
          for (final (i, rssi) in [-70, -72, -74, -90].indexed)
            BleSample(
              key: 'a',
              rssi: rssi,
              serviceUuids: const [],
              monotonicNanos: i,
              // The first reading is older than 30 s and left out.
              wallClockMillis: i == 0 ? 0 : 40000 + i,
            ),
        ]);
      final summary = tracker.snapshot().devices.single;
      expect(summary.median, const Dbm(-74));
      expect(summary.spread!.value, closeTo(9.87, 0.01)); // sample std dev
    });
  });

  group('surface phones', () {
    test('heard strongly enough and often enough during the scan', () {
      final heard = [
        device('team', median: -60),
        device('edge', median: -80),
        device('faint', median: -81),
        device('once', median: -50, samples: 2),
        device('silent'),
      ];
      expect(surfacePhones(heard), ['team', 'edge']);
    });
  });

  group('candidates', () {
    test(
      'a phone that says it is trapped comes first, even strong and moving',
      () {
        final ranked = rankCandidates(
          [
            device(
              'findmy',
              kind: DeviceKind.appleFindMy,
              median: -85,
              spread: 2,
            ),
            device(
              'sos-0007',
              kind: DeviceKind.trappedBeacon,
              median: -50,
              spread: 9,
            ),
          ],
          surface: const {},
          targets: const {},
        );
        expect(ranked.first.device.key, 'sos-0007');
      },
    );

    test('a trapped beacon is never set aside as a surface phone', () {
      expect(
        surfacePhones([
          device('sos-0007', kind: DeviceKind.trappedBeacon, median: -60),
          device('rescuer', median: -60),
        ]),
        ['rescuer'],
      );
    });

    test('Find My, still and weak come first; strong and surface phones last or out', () {
      final ranked = rankCandidates(
        [
          device('strong', median: -50, spread: 2),
          device(
            'findmy',
            kind: DeviceKind.appleFindMy,
            median: -85,
            spread: 2,
          ),
          device('moving', median: -85, spread: 9),
          device('still', median: -85, spread: 2),
          device('surface', median: -85, spread: 2),
          device('target', median: -85, spread: 2),
        ],
        surface: {'surface'},
        targets: {'target'},
      );
      expect(ranked.map((c) => c.device.key), [
        'findmy',
        'still',
        'moving',
        'strong',
      ]);
    });

    test('reasons in plain flags', () {
      final [still, changing, strong] = rankCandidates(
        [
          device('still', median: -85, spread: 2),
          device('changing', median: -70, spread: 9),
          device('strong', median: -45, spread: 1),
        ],
        surface: const {},
        targets: const {},
      );
      expect(
        (still.movement, still.strength),
        (Movement.still, SignalStrength.weak),
      );
      expect(
        (changing.movement, changing.strength),
        (Movement.changing, SignalStrength.medium),
      );
      expect(strong.strength, SignalStrength.veryStrong);
    });

    test('few recent readings are "not known yet", never "moving"', () {
      final [c] = rankCandidates(
        [device('faint', median: -95, spread: 12, samples: 40, recent: 3)],
        surface: const {},
        targets: const {},
      );
      expect(c.movement, Movement.notKnownYet);
    });

    test('a faint device heard rarely ranks above a changing one', () {
      final ranked = rankCandidates(
        [
          device('changing', median: -85, spread: 9),
          device('faint', median: -95, recent: 2),
        ],
        surface: const {},
        targets: const {},
      );
      expect(ranked.map((c) => c.device.key), ['faint', 'changing']);
    });
  });

  group('stable order', () {
    test('cards keep their place; new devices come last', () {
      final ranked = rankCandidates(
        [
          device(
            'new-findmy',
            kind: DeviceKind.appleFindMy,
            median: -85,
            spread: 2,
          ),
          device('a', median: -85, spread: 2),
          device('b', median: -70, spread: 9),
        ],
        surface: const {},
        targets: const {},
      );
      final shown = keepOrder(['b', 'a', 'gone'], ranked);
      expect(shown.map((c) => c.device.key), ['b', 'a', 'new-findmy']);
    });
  });
}
