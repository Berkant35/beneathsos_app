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
}) => DeviceSummary(
  key: key,
  kind: kind,
  lastRssi: median?.round() ?? -90,
  firstSeenMillis: 0,
  lastSeenMillis: 30000,
  sampleCount: samples,
  median: median == null ? null : Dbm(median),
  spread: spread == null ? null : Decibels(spread),
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
      final [still, moving, strong] = rankCandidates(
        [
          device('still', median: -85, spread: 2),
          device('moving', median: -70, spread: 9),
          device('strong', median: -45, spread: 1),
        ],
        surface: const {},
        targets: const {},
      );
      expect((still.still, still.strength), (true, SignalStrength.weak));
      expect((moving.still, moving.strength), (false, SignalStrength.medium));
      expect(strong.strength, SignalStrength.veryStrong);
    });

    test('too few readings are not called still', () {
      final [c] = rankCandidates(
        [device('new', median: -85, spread: 1, samples: 3)],
        surface: const {},
        targets: const {},
      );
      expect(c.still, isFalse);
    });
  });
}
