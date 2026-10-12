import 'package:beneathsos_app/core/scanning/domain/scan_preconditions.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';
import 'package:beneathsos_app/core/scanning/domain/start_scan_result.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes.dart';

void main() {
  group('PermissionPrecondition', () {
    test('passes without prompting when already granted', () async {
      final permissions = FakePermissions(checkResult: ScanPermission.granted);

      expect(await PermissionPrecondition(permissions).check(), isNull);
      expect(permissions.calls, ['check']);
    });

    test('asks once when denied and passes if the user grants', () async {
      final permissions = FakePermissions(checkResult: ScanPermission.denied);

      expect(await PermissionPrecondition(permissions).check(), isNull);
      expect(permissions.calls, ['check', 'request']);
    });

    test('blocks (not permanent) when the user denies the prompt', () async {
      final permissions = FakePermissions(
        checkResult: ScanPermission.denied,
        requestResult: ScanPermission.denied,
      );

      final result = await PermissionPrecondition(permissions).check();

      expect(
        result,
        isA<PermissionMissing>().having((r) => r.permanent, 'permanent', false),
      );
    });

    test(
      'blocks permanently without prompting when permanently denied',
      () async {
        final permissions = FakePermissions(
          checkResult: ScanPermission.permanentlyDenied,
        );

        final result = await PermissionPrecondition(permissions).check();

        expect(
          result,
          isA<PermissionMissing>().having(
            (r) => r.permanent,
            'permanent',
            true,
          ),
        );
        expect(permissions.calls, ['check']);
      },
    );
  });

  test(
    'PermissionPrecondition with ask: false only checks, never requests',
    () async {
      final permissions = FakePermissions(checkResult: ScanPermission.denied);
      final result = await PermissionPrecondition(
        permissions,
        ask: false,
      ).check();
      expect(
        result,
        isA<PermissionMissing>().having((r) => r.permanent, 'permanent', false),
      );
      expect(permissions.calls, ['check']);
    },
  );

  group('BluetoothPrecondition', () {
    Future<Object?> checkWith(BluetoothAvailability availability) =>
        BluetoothPrecondition(FakeScanner()..availability = availability)
            .check();

    test('passes when Bluetooth is on', () async {
      expect(await checkWith(BluetoothAvailability.on), isNull);
    });

    test(
      'passes when still unknown after settling (platform reports failures)',
      () async {
        expect(await checkWith(BluetoothAvailability.unknown), isNull);
      },
    );

    test('blocks when off or unsupported', () async {
      expect(
        await checkWith(BluetoothAvailability.off),
        isA<BluetoothUnavailable>().having(
          (r) => r.reason,
          'reason',
          BluetoothUnavailableReason.off,
        ),
      );
      expect(
        await checkWith(BluetoothAvailability.unsupported),
        isA<BluetoothUnavailable>().having(
          (r) => r.reason,
          'reason',
          BluetoothUnavailableReason.unsupported,
        ),
      );
    });

    test('unauthorised Bluetooth is a permanent permission problem', () async {
      expect(
        await checkWith(BluetoothAvailability.unauthorized),
        isA<PermissionMissing>().having((r) => r.permanent, 'permanent', true),
      );
    });
  });

  test('BluetoothPrecondition with unknownBlocks: a still-unknown adapter is not ready yet', () async {
    final scanner = FakeScanner()..availability = BluetoothAvailability.unknown;
    expect(
      await BluetoothPrecondition(scanner, unknownBlocks: true).check(),
      isA<BluetoothUnavailable>().having(
        (r) => r.reason,
        'reason',
        BluetoothUnavailableReason.notReady,
      ),
    );
    expect(
      await BluetoothPrecondition(scanner).check(),
      isNull,
    ); // scanning still tries anyway
  });
}
