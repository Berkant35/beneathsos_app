import 'package:beneathsos_app/core/readiness/domain/check_readiness.dart';
import 'package:beneathsos_app/core/readiness/domain/device_readiness.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../scanning/fakes.dart';

void main() {
  late FakeScanner scanner;
  late FakePermissions permissions;

  setUp(() {
    scanner = FakeScanner();
    permissions = FakePermissions(checkResult: ScanPermission.granted);
  });
  tearDown(() => scanner.close());

  Future<DeviceReadiness> check({bool ask = false}) => CheckReadiness(
    permissions: permissions,
    scanner: scanner,
  )(askForPermission: ask);

  test(
    'permission and Bluetooth fine → ready, and a scan is never started',
    () async {
      expect(await check(), isA<ReadinessReady>());
      expect(scanner.calls, isEmpty);
    },
  );

  test('missing permission is asked when allowed; granted → ready', () async {
    permissions
      ..checkResult = ScanPermission.denied
      ..requestResult = ScanPermission.granted;
    expect(await check(ask: true), isA<ReadinessReady>());
    expect(permissions.calls, ['check', 'request']);
  });

  test(
    'missing permission, asking not allowed → needs permission, no dialog',
    () async {
      permissions.checkResult = ScanPermission.denied;
      expect(await check(), isA<ReadinessNeedsPermission>());
      expect(permissions.calls, ['check']);
    },
  );

  test('permanently denied → settings', () async {
    permissions.checkResult = ScanPermission.permanentlyDenied;
    expect(await check(ask: true), isA<ReadinessPermissionInSettings>());
  });

  test('iOS Bluetooth unauthorised → settings', () async {
    scanner.availability = BluetoothAvailability.unauthorized;
    expect(await check(), isA<ReadinessPermissionInSettings>());
  });

  test('Bluetooth off → off', () async {
    scanner.availability = BluetoothAvailability.off;
    expect(await check(), isA<ReadinessBluetoothOff>());
  });

  test('no Bluetooth LE → unsupported', () async {
    scanner.availability = BluetoothAvailability.unsupported;
    expect(await check(), isA<ReadinessUnsupported>());
  });

  test('permission and Bluetooth both missing → permission first (the app can fix it)', () async {
    permissions.checkResult = ScanPermission.denied;
    scanner.availability = BluetoothAvailability.off;
    expect(await check(), isA<ReadinessNeedsPermission>());
  });
}
