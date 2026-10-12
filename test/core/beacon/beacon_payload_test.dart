import 'dart:typed_data';

import 'package:beneathsos_app/core/beacon/domain/beacon_payload.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'the payload is version, id, battery and minutes since the last touch',
    () {
      const payload = BeaconPayload(
        id: 0x1a2b,
        batteryPercent: 80,
        sinceTouch: Duration(minutes: 3, seconds: 59),
      );
      expect(payload.encode(), [1, 0x1a, 0x2b, 80, 3]);
      expect(payload.localName, 'SOS-1A2B');
    },
  );

  test('unknown battery and long silences have their own values', () {
    expect(
      const BeaconPayload(id: 1, sinceTouch: Duration(hours: 9)).encode(),
      [1, 0, 1, 0xff, 0xff],
    );
    expect(
      const BeaconPayload(
        id: 1,
        batteryPercent: 140,
        sinceTouch: Duration(minutes: 254),
      ).encode()[3],
      100,
    );
  });

  test('decoding gives back what was sent', () {
    final decoded = BeaconPayload.decode(
      Uint8List.fromList([1, 0, 7, 55, 12]),
    )!;
    expect(decoded.id, 7);
    expect(decoded.batteryPercent, 55);
    expect(decoded.sinceTouch, const Duration(minutes: 12));
    expect(
      BeaconPayload.decode(Uint8List.fromList([1, 0, 7, 0xff, 0xff]))!
          .batteryPercent,
      isNull,
    );
    // Another version or a short packet is not ours to read.
    expect(BeaconPayload.decode(Uint8List.fromList([2, 0, 7, 55, 12])), isNull);
    expect(BeaconPayload.decode(Uint8List.fromList([1, 0])), isNull);
  });

  group('beaconKey', () {
    final android = {
      beaconServiceUuid: Uint8List.fromList([1, 0x1a, 0x2b, 80, 3]),
    };

    test('from the service data (Android victims)', () {
      expect(
        beaconKey(
          serviceUuids: const [beaconServiceUuid],
          serviceData: android,
        ),
        'sos-1a2b',
      );
    });

    test('from the local name (iOS victims), UUID in any case', () {
      expect(
        beaconKey(
          serviceUuids: [beaconServiceUuid.toUpperCase()],
          localName: 'SOS-1A2B',
        ),
        'sos-1a2b',
      );
    });

    test('a beacon without an id still counts, by its UUID', () {
      expect(
        beaconKey(serviceUuids: [beaconServiceUuid.toUpperCase()]),
        'sos-unknown',
      );
    });

    test('anything else is not a beacon', () {
      expect(beaconKey(serviceUuids: const [], localName: 'SOS-1A2B'), isNull);
      expect(beaconKey(serviceUuids: const ['180d']), isNull);
    });
  });
}
