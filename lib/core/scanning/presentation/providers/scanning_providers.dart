import 'package:beneathsos_app/core/scanning/domain/scan_ports.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_preconditions.dart';
import 'package:beneathsos_app/core/scanning/domain/start_scan.dart';
import 'package:beneathsos_app/core/scanning/domain/stop_scan.dart';
import 'package:beneathsos_app/core/services/ble_service.dart';
import 'package:beneathsos_app/core/services/permission_service.dart';
import 'package:beneathsos_app/core/services/wakelock_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scanning_providers.g.dart';

// Port bindings: the only place that decides which implementation backs each port.
// Tests override these three providers with fakes.

/// Bluetooth radio.
@Riverpod(keepAlive: true)
ScannerPort scannerPort(Ref ref) => ref.watch(bleServiceProvider);

/// Runtime permissions.
@Riverpod(keepAlive: true)
ScanPermissionPort scanPermissionPort(Ref ref) =>
    ref.watch(permissionServiceProvider);

/// Screen keep-awake.
@Riverpod(keepAlive: true)
ScreenAwakePort screenAwakePort(Ref ref) => ref.watch(wakelockServiceProvider);

// Use cases.

/// Starts scanning after permission and Bluetooth checks (in this order).
@Riverpod(keepAlive: true)
StartScan startScan(Ref ref) {
  final scanner = ref.watch(scannerPortProvider);
  return StartScan(
    preconditions: [
      PermissionPrecondition(ref.watch(scanPermissionPortProvider)),
      BluetoothPrecondition(scanner),
    ],
    scanner: scanner,
    screen: ref.watch(screenAwakePortProvider),
  );
}

/// Stops scanning.
@Riverpod(keepAlive: true)
StopScan stopScan(Ref ref) => StopScan(
  scanner: ref.watch(scannerPortProvider),
  screen: ref.watch(screenAwakePortProvider),
);
