import 'dart:async';

import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';
import 'package:beneathsos_app/core/scanning/presentation/providers/scan_controller.dart';
import 'package:beneathsos_app/core/scanning/presentation/providers/scan_state.dart';
import 'package:beneathsos_app/core/scanning/presentation/providers/scanning_providers.dart';
import 'package:beneathsos_app/core/services/app_lifecycle.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes.dart';

void main() {
  late FakeScanner scanner;
  late FakePermissions permissions;
  late FakeScreen screen;
  late StreamController<AppLifecycleState> lifecycle;
  late ProviderContainer container;

  setUp(() {
    scanner = FakeScanner();
    permissions = FakePermissions(checkResult: ScanPermission.granted);
    screen = FakeScreen();
    lifecycle = StreamController<AppLifecycleState>();
    container = ProviderContainer(
      overrides: [
        scannerPortProvider.overrideWithValue(scanner),
        scanPermissionPortProvider.overrideWithValue(permissions),
        screenAwakePortProvider.overrideWithValue(screen),
        appLifecycleProvider.overrideWith((ref) => lifecycle.stream),
      ],
    );
    // Keep a listener like the status bar does: Riverpod 3 pauses unwatched providers,
    // and a paused provider does not receive stream or lifecycle events.
    container.listen(scanControllerProvider, (_, _) {});
  });

  tearDown(() async {
    container.dispose();
    await lifecycle.close();
    await scanner.close();
  });

  ScanController controller() =>
      container.read(scanControllerProvider.notifier);
  ScanState state() => container.read(scanControllerProvider);

  test('starts scanning when permissions and Bluetooth are fine', () async {
    await controller().start();

    expect(state(), isA<ScanRunning>());
    expect(scanner.calls, ['start']);
    expect(screen.changes, [true]);
  });

  test('unsupported Bluetooth (simulator) is shown as Bluetooth off', () async {
    scanner.availability = BluetoothAvailability.unsupported;

    await controller().start();

    expect(state(), isA<ScanBluetoothOff>());
    expect(scanner.calls, isEmpty);
  });

  test(
    'permanently denied permission asks the user to open Settings',
    () async {
      permissions.checkResult = ScanPermission.permanentlyDenied;

      await controller().start();

      expect(
        state(),
        isA<ScanNeedsPermission>().having(
          (s) => s.permanent,
          'permanent',
          true,
        ),
      );
    },
  );

  test('Bluetooth turned off while scanning stops showing "running"', () async {
    await controller().start();

    scanner.emitAvailability(BluetoothAvailability.off);
    await pumpEventQueue();

    expect(state(), isA<ScanBluetoothOff>());
  });

  test(
    'Bluetooth turned back on restarts a scan that was waiting for it',
    () async {
      scanner.availability = BluetoothAvailability.off;
      await controller().start();
      expect(state(), isA<ScanBluetoothOff>());

      scanner.emitAvailability(BluetoothAvailability.on);
      await pumpEventQueue();

      expect(state(), isA<ScanRunning>());
    },
  );

  test('platform scan errors are shown', () async {
    await controller().start();

    scanner.emitError('scan failed: 2');
    await pumpEventQueue();

    expect(
      state(),
      isA<ScanFailed>().having((s) => s.reason, 'reason', 'scan failed: 2'),
    );
  });

  test('returning from Settings retries only when blocked', () async {
    permissions.checkResult = ScanPermission.permanentlyDenied;
    await controller().start();
    expect(state(), isA<ScanNeedsPermission>());

    // User grants the permission in Settings and comes back.
    permissions.checkResult = ScanPermission.granted;
    lifecycle
      ..add(AppLifecycleState.paused)
      ..add(AppLifecycleState.resumed);
    await pumpEventQueue();

    expect(state(), isA<ScanRunning>());
    expect(scanner.calls, ['start']);
  });

  test('stop stops the scanner and returns to idle', () async {
    await controller().start();

    await controller().stop();

    expect(state(), isA<ScanIdle>());
    expect(scanner.calls, ['start', 'stop']);
    expect(screen.changes, [true, false]);
  });

  test(
    'a stop while the start is still pending leaves the radio and screen off',
    () async {
      scanner.startGate = Completer<void>();
      final starting = controller().start();
      await pumpEventQueue();
      final stopping = controller().stop();
      scanner.startGate!.complete();
      await starting;
      await stopping;
      expect(state(), isA<ScanIdle>());
      expect(scanner.calls.last, 'stop');
      expect(screen.changes.last, isFalse);
    },
  );
}
