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

/// Scanning permissions must be granted; asks once when they are missing (unless [ask] is false).
final class PermissionPrecondition implements ScanPrecondition {
  /// Creates the precondition.
  const PermissionPrecondition(this._permissions, {this.ask = true});

  final ScanPermissionPort _permissions;

  /// Whether a missing permission is requested (false: only checked).
  final bool ask;

  @override
  Future<StartScanResult?> check() async {
    var permission = await _permissions.check();
    if (ask && permission == ScanPermission.denied) {
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
  /// Creates the precondition. With [unknownBlocks], a still-unknown adapter blocks (readiness must
  /// not reassure); without it, scanning tries anyway and the platform reports failures.
  const BluetoothPrecondition(this._scanner, {this.unknownBlocks = false});

  final ScannerPort _scanner;

  /// Whether `unknown` (not reported yet) counts as not ready.
  final bool unknownBlocks;

  @override
  Future<StartScanResult?> check() async =>
      switch (await _scanner.settledAvailability()) {
        BluetoothAvailability.unauthorized => const PermissionMissing(
          permanent: true,
        ),
        BluetoothAvailability.off => const BluetoothUnavailable(),
        BluetoothAvailability.unsupported => const BluetoothUnavailable(
          BluetoothUnavailableReason.unsupported,
        ),
        BluetoothAvailability.unknown when unknownBlocks =>
          const BluetoothUnavailable(BluetoothUnavailableReason.notReady),
        BluetoothAvailability.on || BluetoothAvailability.unknown => null,
      };
}
