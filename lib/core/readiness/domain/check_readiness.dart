import 'package:beneathsos_app/core/readiness/domain/device_readiness.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_ports.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_preconditions.dart';
import 'package:beneathsos_app/core/scanning/domain/start_scan_result.dart';

/// "Can this phone search right now?" — the same preconditions scanning uses (permission first,
/// then Bluetooth), without starting a scan.
final class CheckReadiness {
  /// Creates the use case.
  const CheckReadiness({required this._permissions, required this._scanner});

  final ScanPermissionPort _permissions;
  final ScannerPort _scanner;

  /// Checks; requests a missing permission only when [askForPermission] is true.
  Future<DeviceReadiness> call({required bool askForPermission}) async {
    final preconditions = [
      PermissionPrecondition(_permissions, ask: askForPermission),
      BluetoothPrecondition(_scanner),
    ];
    for (final precondition in preconditions) {
      final blocked = await precondition.check();
      if (blocked != null) return _readiness(blocked);
    }
    return const ReadinessReady();
  }

  static DeviceReadiness _readiness(StartScanResult blocked) =>
      switch (blocked) {
        PermissionMissing(permanent: false) => const ReadinessNeedsPermission(),
        PermissionMissing(permanent: true) =>
          const ReadinessPermissionInSettings(),
        BluetoothUnavailable(unsupported: true) => const ReadinessUnsupported(),
        BluetoothUnavailable() => const ReadinessBluetoothOff(),
        // Preconditions only block with the two results above.
        ScanStarted() || StartFailed() => const ReadinessReady(),
      };
}
