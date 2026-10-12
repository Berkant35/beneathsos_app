import 'package:beneathsos_app/core/models/ble_sample.dart';
import 'package:beneathsos_app/features/measurement/domain/measurement_rules.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubble_core/rubble_core.dart';

BleSample s(String key, int rssi, int at) => BleSample(
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
    test('the median of the target identity, its count; a target not heard is NoSignal', () {
      final readings = summarizeReadings(
        {phone: 'apple-1', watch: 'apple-2'},
        [
          s('apple-1', -80, 1),
          s('other', -40, 2),
          s('apple-1', -84, 3),
          s('apple-1', -90, 4),
        ],
      );
      expect(readings, [
        SignalHeard(phone, median: const Dbm(-84), samples: 3),
        const NoSignal(watch),
      ]);
    });

    test('implausible values are dropped, not averaged in', () {
      final readings = summarizeReadings(
        {phone: 'apple-1'},
        [s('apple-1', 127, 1), s('apple-1', -70, 2)],
      );
      expect(
        readings.single,
        SignalHeard(phone, median: const Dbm(-70), samples: 1),
      );
    });
  });

  test('a strong acceleration is movement, a light one is not', () {
    expect(isMovement(0.3), isFalse);
    expect(isMovement(1.5), isTrue);
  });
}
