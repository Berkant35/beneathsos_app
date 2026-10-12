import 'package:beneathsos_app/core/beacon/domain/beacon_payload.dart';
import 'package:beneathsos_app/core/beacon/domain/start_beacon.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';
import 'package:flutter_test/flutter_test.dart';

import '../scanning/fakes.dart';
import 'fakes.dart';

void main() {
  const payload = BeaconPayload(id: 7, sinceTouch: Duration.zero);

  Future<BeaconStart> start(FakeBeacon beacon, FakePermissions permissions) =>
      StartBeacon(beacon, permissions)(payload);

  test('with permission and Bluetooth on, the beacon calls out', () async {
    final beacon = FakeBeacon();
    expect(
      await start(beacon, FakePermissions(checkResult: ScanPermission.granted)),
      isA<BeaconStarted>(),
    );
    expect(beacon.sent, [payload]);
  });

  test('a missing permission is asked for at once', () async {
    final beacon = FakeBeacon();
    final permissions = FakePermissions(checkResult: ScanPermission.denied);
    expect(await start(beacon, permissions), isA<BeaconStarted>());
    expect(permissions.calls, ['check', 'request']);
  });

  test('a refused permission says whether only Settings can fix it', () async {
    final beacon = FakeBeacon();
    expect(
      await start(
        beacon,
        FakePermissions(
          checkResult: ScanPermission.denied,
          requestResult: ScanPermission.permanentlyDenied,
        ),
      ),
      isA<BeaconNeedsPermission>().having(
        (r) => r.permanently,
        'permanently',
        true,
      ),
    );
    expect(beacon.sent, isEmpty);
  });

  test(
    'Bluetooth off, denied on iOS, or no advertising: nothing is sent',
    () async {
      final granted = FakePermissions(checkResult: ScanPermission.granted);
      expect(
        await start(
          FakeBeacon(availability: BluetoothAvailability.off),
          granted,
        ),
        isA<BeaconBluetoothOff>(),
      );
      expect(
        await start(
          FakeBeacon(availability: BluetoothAvailability.unauthorized),
          granted,
        ),
        isA<BeaconNeedsPermission>().having(
          (r) => r.permanently,
          'permanently',
          true,
        ),
      );
      expect(
        await start(
          FakeBeacon(availability: BluetoothAvailability.unsupported),
          granted,
        ),
        isA<BeaconUnsupported>(),
      );
      final noAdvertising = FakeBeacon(canAdvertise: false);
      expect(await start(noAdvertising, granted), isA<BeaconUnsupported>());
      expect(noAdvertising.sent, isEmpty);
    },
  );
}
