import 'package:beneathsos_app/features/targets/domain/device_kind.dart';
import 'package:beneathsos_app/features/targets/domain/device_tracker.dart';
import 'package:beneathsos_app/features/targets/domain/presence_event.dart';
import 'package:beneathsos_app/features/targets/domain/tracker_policy.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/samples.dart';

/// Seconds → wall-clock milliseconds, for readable timelines.
int s(num seconds) => (seconds * 1000).round();

void main() {
  late DeviceTracker tracker;

  // Defaults: warm-up 5 s, gone after 15 s, forget after 30 s.
  setUp(() => tracker = DeviceTracker());

  List<(String, PresenceChange)> log() => [
    for (final e in tracker.snapshot().events) (e.key, e.change),
  ];
  List<String> devices() => [for (final d in tracker.snapshot().devices) d.key];

  group('appearing', () {
    test('identities already around during the warm-up are not logged', () {
      tracker.ingest([sample(key: 'A', at: s(0)), sample(key: 'B', at: s(5))]);

      expect(devices(), ['A', 'B']);
      expect(log(), isEmpty);
    });

    test(
      'a new identity after the warm-up is logged with its time and RSSI',
      () {
        tracker
          ..ingest([sample(key: 'A', at: s(0))])
          ..ingest([sample(key: 'B', at: s(8), rssi: -81)]);

        final event = tracker.snapshot().events.single;
        expect(
          (event.key, event.change, event.atMillis, event.rssi),
          ('B', PresenceChange.appeared, s(8), -81),
        );
      },
    );

    test('summaries carry kind, last RSSI, first/last seen and count', () {
      tracker.ingest([
        sample(
          key: 'F',
          at: s(1),
          rssi: -72,
          companyId: 0x004C,
          payload: [0x12],
        ),
        sample(
          key: 'F',
          at: s(2),
          rssi: -66,
          companyId: 0x004C,
          payload: [0x12],
        ),
      ]);

      final d = tracker.snapshot().devices.single;
      expect(d.kind, DeviceKind.appleFindMy);
      expect(
        (d.lastRssi, d.firstSeenMillis, d.lastSeenMillis, d.sampleCount),
        (-66, s(1), s(2), 2),
      );
    });
  });

  group('going silent', () {
    test('"gone" is logged once, only after more than 15 s of silence', () {
      tracker.ingest([sample(key: 'A', at: s(0))]);

      expect(
        tracker.tick(s(15)),
        isFalse,
        reason: 'exactly 15 s is not yet gone',
      );
      expect(tracker.tick(s(16)), isTrue);
      expect(tracker.tick(s(17)), isFalse, reason: 'no duplicate gone event');
      expect(log(), [('A', PresenceChange.gone)]);
      expect(devices(), ['A'], reason: 'still listed until forgotten');
    });

    test('a device heard again can go silent again later', () {
      tracker
        ..ingest([sample(key: 'A', at: s(0))])
        ..tick(s(16))
        ..ingest([sample(key: 'A', at: s(20))])
        ..tick(s(36));

      expect(log(), [('A', PresenceChange.gone), ('A', PresenceChange.gone)]);
    });

    test(
      'after 30 s of silence the device leaves the list but stays in the log',
      () {
        tracker
          ..ingest([sample(key: 'A', at: s(0)), sample(key: 'B', at: s(0))])
          ..tick(s(16))
          ..ingest([sample(key: 'B', at: s(25))]);

        expect(tracker.tick(s(31)), isTrue);
        expect(devices(), ['B']);
        expect(log(), [('A', PresenceChange.gone), ('B', PresenceChange.gone)]);
      },
    );

    test('a forgotten identity that returns is a new appearance', () {
      tracker
        ..ingest([sample(key: 'A', at: s(0))])
        ..tick(s(31))
        ..ingest([sample(key: 'A', at: s(40))]);

      expect(devices(), ['A']);
      expect(log(), [
        ('A', PresenceChange.gone),
        ('A', PresenceChange.appeared),
      ]);
    });

    test('a long pause between ticks still logs "gone" before forgetting', () {
      tracker
        ..ingest([sample(key: 'A', at: s(0), rssi: -77)])
        ..tick(s(120));

      expect(devices(), isEmpty);
      final gone = tracker.snapshot().events.single;
      expect(
        (gone.change, gone.atMillis, gone.rssi),
        (PresenceChange.gone, s(120), -77),
      );
    });
  });

  test('the log keeps only the newest maxEvents entries', () {
    tracker = DeviceTracker(policy: const TrackerPolicy(maxEvents: 2));
    tracker.ingest([sample(key: 'A', at: s(0))]);
    for (final key in ['B', 'C', 'D']) {
      tracker.ingest([sample(key: key, at: s(10))]);
    }

    expect(log(), [
      ('C', PresenceChange.appeared),
      ('D', PresenceChange.appeared),
    ]);
  });

  test('a snapshot does not change when the tracker moves on', () {
    tracker.ingest([sample(key: 'A', at: s(0), rssi: -72)]);
    final before = tracker.snapshot();

    tracker
      ..ingest([
        sample(key: 'A', at: s(1), rssi: -50),
        sample(key: 'B', at: s(9)),
      ])
      ..tick(s(60));

    expect(before.devices.single.lastRssi, -72);
    expect(before.devices, hasLength(1));
    expect(before.events, isEmpty);
    expect(
      () => before.devices.add(before.devices.first),
      throwsUnsupportedError,
    );
  });

  test('reset forgets everything, including the warm-up start', () {
    tracker
      ..ingest([sample(key: 'A', at: s(0))])
      ..tick(s(16))
      ..reset()
      ..ingest([sample(key: 'B', at: s(100))]);

    expect(devices(), ['B']);
    expect(log(), isEmpty, reason: 'B is inside the new warm-up');
    expect(tracker.snapshot().startedMillis, s(100));
  });
}
