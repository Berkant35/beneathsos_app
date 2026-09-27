import 'dart:async';

import 'package:beneathsos_app/core/services/ble_service.dart';
import 'package:beneathsos_app/core/services/permission_service.dart';
import 'package:beneathsos_app/core/services/wakelock_service.dart';
import 'package:beneathsos_app/features/field_test/presentation/providers/scan_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _FakeBle extends Mock implements BleService {}

class _FakePermissions extends Mock implements PermissionService {}

class _FakeWakelock extends Mock implements WakelockService {}

void main() {
  late _FakeBle ble;
  late StreamController<BluetoothAvailability> adapter;
  late ProviderContainer container;

  setUp(() {
    ble = _FakeBle();
    adapter = StreamController<BluetoothAvailability>.broadcast();
    final permissions = _FakePermissions();
    final wakelock = _FakeWakelock();
    when(() => ble.errors).thenAnswer((_) => const Stream.empty());
    when(() => ble.availabilityChanges).thenAnswer((_) => adapter.stream);
    when(ble.start).thenAnswer((_) async {});
    when(permissions.check).thenAnswer((_) async => ScanPermission.granted);
    when(() => wakelock.keepAwake(enabled: any(named: 'enabled')))
        .thenAnswer((_) async {});
    container = ProviderContainer(
      overrides: [
        bleServiceProvider.overrideWithValue(ble),
        permissionServiceProvider.overrideWithValue(permissions),
        wakelockServiceProvider.overrideWithValue(wakelock),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await adapter.close();
  });

  test(
    'waits for iOS to settle and reports unsupported Bluetooth (simulator)',
    () async {
      when(ble.availability)
          .thenAnswer((_) async => BluetoothAvailability.unknown);
      container.read(scanControllerProvider);

      final starting = container.read(scanControllerProvider.notifier).start();
      await Future<void>.delayed(Duration.zero);
      adapter.add(BluetoothAvailability.unsupported);
      await starting;

      expect(container.read(scanControllerProvider), isA<ScanBluetoothOff>());
      verifyNever(ble.start);
    },
  );

  test('Bluetooth turned off while scanning stops showing "running"', () async {
    when(ble.availability).thenAnswer((_) async => BluetoothAvailability.on);
    container.read(scanControllerProvider);
    await container.read(scanControllerProvider.notifier).start();
    expect(container.read(scanControllerProvider), isA<ScanRunning>());

    adapter.add(BluetoothAvailability.off);
    await Future<void>.delayed(Duration.zero);

    expect(container.read(scanControllerProvider), isA<ScanBluetoothOff>());
  });
}
