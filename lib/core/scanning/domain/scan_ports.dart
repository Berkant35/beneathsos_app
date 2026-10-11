import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';

/// What the scanning domain needs from the Bluetooth radio.
///
/// Implemented in `core/services`; platform quirks stay in the implementation.
abstract interface class ScannerPort {
  /// The definitive adapter state. Implementations wait briefly when the platform
  /// first reports [BluetoothAvailability.unknown].
  Future<BluetoothAvailability> settledAvailability();

  /// Adapter state changes while the app runs.
  Stream<BluetoothAvailability> get availabilityChanges;

  /// Asynchronous scan failures as text.
  Stream<String> get errors;

  /// Starts scanning.
  Future<void> start();

  /// Stops scanning.
  Future<void> stop();
}

/// What the scanning domain needs from the permission system.
abstract interface class ScanPermissionPort {
  /// Current state without prompting.
  Future<ScanPermission> check();

  /// Prompts the user for missing permissions.
  Future<ScanPermission> request();

  /// Opens the OS settings page of the app.
  Future<void> openSettings();
}

/// Keeps the screen on while scanning (iOS scans only in the foreground).
abstract interface class ScreenAwakePort {
  /// Enables or disables keeping the screen awake.
  Future<void> keepAwake({required bool enabled});
}
