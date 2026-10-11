import 'package:beneathsos_app/core/scanning/domain/availability_policy.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Bluetooth turned off while scanning is shown; ignored otherwise', () {
    expect(
      reactToAvailability(BluetoothAvailability.off, ScanActivity.scanning),
      AvailabilityReaction.markBluetoothUnavailable,
    );
    expect(
      reactToAvailability(
        BluetoothAvailability.unsupported,
        ScanActivity.scanning,
      ),
      AvailabilityReaction.markBluetoothUnavailable,
    );
    expect(
      reactToAvailability(BluetoothAvailability.off, ScanActivity.idle),
      AvailabilityReaction.none,
    );
  });

  test(
    'Bluetooth coming back restarts only a scan that was waiting for it',
    () {
      expect(
        reactToAvailability(
          BluetoothAvailability.on,
          ScanActivity.waitingForBluetooth,
        ),
        AvailabilityReaction.restart,
      );
      for (final activity in ScanActivity.values.where(
        (a) => a != ScanActivity.waitingForBluetooth,
      )) {
        expect(
          reactToAvailability(BluetoothAvailability.on, activity),
          AvailabilityReaction.none,
        );
      }
    },
  );

  test(
    'losing Bluetooth authorisation always marks the permission missing',
    () {
      for (final activity in ScanActivity.values) {
        expect(
          reactToAvailability(BluetoothAvailability.unauthorized, activity),
          AvailabilityReaction.markPermissionMissing,
        );
      }
    },
  );

  test('unknown never triggers anything', () {
    for (final activity in ScanActivity.values) {
      expect(
        reactToAvailability(BluetoothAvailability.unknown, activity),
        AvailabilityReaction.none,
      );
    }
  });
}
