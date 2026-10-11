import 'package:beneathsos_app/core/scanning/domain/scan_ports.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';
import 'package:beneathsos_app/core/scanning/domain/start_scan_result.dart';

/// One condition that must hold before scanning starts.
///
/// New rules are new implementations added to the list given to `StartScan`.
abstract interface class ScanPrecondition {
  /// Returns `null` when the condition holds, otherwise the result that blocks the scan.
  Future<StartScanResult?> check();
}

/// Scanning permissions must be granted; asks once when they are missing.
final class PermissionPrecondition implements ScanPrecondition {
  /// Creates the precondition.
  const PermissionPrecondition(this._permissions);

  final ScanPermissionPort _permissions;

  @override
  Future<StartScanResult?> check() async {
    var permission = await _permissions.check();
    if (permission == ScanPermission.denied) {
      permission = await _permissions.request();
    }
    return switch (permission) {
      ScanPermission.granted => null,
      ScanPermission.denied => const PermissionMissing(permanent: false),
      ScanPermission.permanentlyDenied => const PermissionMissing(
        permanent: true,
      ),
    };
  }
}

/// Bluetooth must be on and authorised.
final class BluetoothPrecondition implements ScanPrecondition {
  /// Creates the precondition.
  const BluetoothPrecondition(this._scanner);

  final ScannerPort _scanner;

  @override
  Future<StartScanResult?> check() async =>
      switch (await _scanner.settledAvailability()) {
        BluetoothAvailability.unauthorized => const PermissionMissing(
          permanent: true,
        ),
        BluetoothAvailability.off ||
        BluetoothAvailability.unsupported => const BluetoothUnavailable(),
        // `unknown` after the settle timeout: try anyway, the platform reports failures.
        BluetoothAvailability.on || BluetoothAvailability.unknown => null,
      };
}
