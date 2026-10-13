import 'package:beneathsos_app/core/models/ble_sample.dart';
import 'package:beneathsos_app/features/measurement/domain/measurement_rules.dart';
import 'package:beneathsos_app/features/targets/domain/device_kind.dart';
import 'package:beneathsos_app/features/targets/domain/presence_event.dart';
import 'package:beneathsos_app/features/targets/domain/tracker_snapshot.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubble_core/rubble_core.dart';

BleSample s(String key, int rssi, [int at = 0]) => BleSample(
  key: key,
  rssi: rssi,
  serviceUuids: const [],
  monotonicNanos: at,
  wallClockMillis: at,
);

void main() {
  const phone = TargetId('t1');
  const watch = TargetId('t2');

  group('readings per target', () {
    test('median and count of the identity; not heard is NoSignal', () {
      final readings = summarizeReadings(
        {phone: 'apple-1', watch: 'apple-2'},
        [
          s('apple-1', -80),
          s('other', -40),
          s('apple-1', -84),
          s('apple-1', -90),
        ],
      );
      expect(readings, [
        SignalHeard(phone, median: const Dbm(-84), samples: 3),
        const NoSignal(watch),
      ]);
    });

    test('fewer than 3 readings, or a median below −100 dBm, is not heard (the engine threshold)', () {
      expect(
        summarizeReadings({phone: 'a'}, [s('a', -70), s('a', -71)]).single,
        const NoSignal(phone),
      );
      expect(
        summarizeReadings(
          {phone: 'a'},
          [s('a', -101), s('a', -102), s('a', -103)],
        ).single,
        const NoSignal(phone),
      );
    });

    test('implausible values are dropped', () {
      final readings = summarizeReadings(
        {phone: 'a'},
        [s('a', 127), s('a', -70), s('a', -70), s('a', -70)],
      );
      expect(
        readings.single,
        SignalHeard(phone, median: const Dbm(-70), samples: 3),
      );
    });
  });

  group('the window of one point', () {
    test('a second counts and keeps its readings only when scanning, in front and still', () {
      final window = MeasurementWindow()..heard([s('a', -80)]);
      expect(window.tick(scanning: true, foreground: true), isFalse);
      expect((window.stillSeconds, window.kept.length), (1, 1));
      window
        ..heard([s('a', -80)])
        ..felt(2.0); // movement later in the same second
      expect(window.tick(scanning: true, foreground: true), isTrue);
      expect((window.stillSeconds, window.kept.length), (1, 1));
      window.heard([s('a', -80)]);
      window.tick(scanning: false, foreground: true); // Bluetooth off
      window.heard([s('a', -80)]);
      window.tick(scanning: true, foreground: false); // in the background
      expect((window.stillSeconds, window.kept.length), (1, 1));
    });

    test('complete after 15 still seconds; how often a key was kept', () {
      final window = MeasurementWindow();
      for (var i = 0; i < 15; i++) {
        window
          ..heard([s('a', -80), s('b', -60)])
          ..tick(scanning: true, foreground: true);
      }
      expect(window.complete, isTrue);
      expect(window.remaining, Duration.zero);
      expect(window.count('a'), 15);
    });

    test('a light shake is not movement', () {
      final window = MeasurementWindow()..felt(0.3);
      expect(window.tick(scanning: true, foreground: true), isFalse);
    });
  });

  group('identity change', () {
    DeviceSummary device(String key, int lastSeen) => DeviceSummary(
      key: key,
      kind: DeviceKind.other,
      lastRssi: -80,
      firstSeenMillis: 0,
      lastSeenMillis: lastSeen,
      sampleCount: 10,
    );
    PresenceEvent event(String key, PresenceChange change, int at) =>
        PresenceEvent(key: key, change: change, atMillis: at, rssi: -80);

    final snapshot = TrackerSnapshot(
      devices: [device('new', 60000)],
      events: [
        event('old', PresenceChange.gone, 30000),
        event('new', PresenceChange.appeared, 25000),
      ],
      startedMillis: 0,
    );

    test('offered while the target is silent, with a gap of zero or more', () {
      final suggestion = relinkSuggestion(
        {phone: 'old'},
        snapshot,
        nowMillis: 60000,
        rejected: const {},
      );
      expect(
        (suggestion!.target, suggestion.from, suggestion.to),
        (phone, 'old', 'new'),
      );
      expect(suggestion.gapSeconds, greaterThanOrEqualTo(0));
    });

    test('not offered once the target is heard again, or after a No', () {
      final back = TrackerSnapshot(
        devices: [device('old', 59000), device('new', 60000)],
        events: snapshot.events,
        startedMillis: 0,
      );
      expect(
        relinkSuggestion(
          {phone: 'old'},
          back,
          nowMillis: 60000,
          rejected: const {},
        ),
        isNull,
      );
      expect(
        relinkSuggestion(
          {phone: 'old'},
          snapshot,
          nowMillis: 60000,
          rejected: {('old', 'new')},
        ),
        isNull,
      );
    });
  });

  test('the measuring time is the one chosen in Settings', () {
    final window = MeasurementWindow(duration: const Duration(seconds: 10));
    for (var i = 0; i < 9; i++) {
      window.tick(scanning: true, foreground: true);
    }
    expect(window.complete, isFalse);
    window.tick(scanning: true, foreground: true);
    expect(window.complete, isTrue);
    expect(MeasurementWindow().duration, MeasurementPolicy.duration);
  });
}
