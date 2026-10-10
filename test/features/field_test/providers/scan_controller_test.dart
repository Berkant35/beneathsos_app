import 'dart:async';

import 'package:beneathsos_app/core/services/app_lifecycle.dart';
import 'package:beneathsos_app/core/services/ble_service.dart';
import 'package:beneathsos_app/core/services/permission_service.dart';
import 'package:beneathsos_app/core/services/wakelock_service.dart';
import 'package:beneathsos_app/features/field_test/presentation/providers/scan_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _FakeBle extends Mock implements BleService {}

class _FakePermissions extends Mock implements PermissionService {}

class _FakeWakelock extends Mock implements WakelockService {}

void main() {
  late _FakeBle ble;
  late _FakePermissions permissions;
  late StreamController<BluetoothAvailability> adapter;
  late StreamController<AppLifecycleState> lifecycle;
  late ProviderContainer container;

  setUp(() {
    ble = _FakeBle();
    adapter = StreamController<BluetoothAvailability>.broadcast();
    lifecycle = StreamController<AppLifecycleState>();
    permissions = _FakePermissions();
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
        appLifecycleProvider.overrideWith((ref) => lifecycle.stream),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await adapter.close();
    await lifecycle.close();
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

  test('returning from Settings retries only when blocked', () async {
    when(ble.availability).thenAnswer((_) async => BluetoothAvailability.on);
    when(permissions.check)
        .thenAnswer((_) async => ScanPermission.permanentlyDenied);
    // Keep a listener like the status bar does: Riverpod 3 pauses unwatched providers,
    // and a paused provider does not receive lifecycle events.
    container.listen(scanControllerProvider, (_, _) {});
    await container.read(scanControllerProvider.notifier).start();
    expect(container.read(scanControllerProvider), isA<ScanNeedsPermission>());

    // User grants the permission in Settings and comes back.
    when(permissions.check).thenAnswer((_) async => ScanPermission.granted);
    lifecycle
      ..add(AppLifecycleState.paused)
      ..add(AppLifecycleState.resumed);
    await pumpEventQueue();

    expect(container.read(scanControllerProvider), isA<ScanRunning>());
    verify(ble.start).called(1);
  });
}
