/// Outcome of trying to start a scan.
sealed class StartScanResult {
  const StartScanResult();
}

/// The scanner is running.
final class ScanStarted extends StartScanResult {
  /// Creates the result.
  const ScanStarted();
}

/// A permission is missing; [permanent] means only OS settings can fix it.
final class PermissionMissing extends StartScanResult {
  /// Creates the result.
  const PermissionMissing({required this.permanent});

  /// Whether the user has to go to the OS settings.
  final bool permanent;
}

/// Why Bluetooth cannot be used.
enum BluetoothUnavailableReason {
  /// Turned off.
  off,

  /// The device has no Bluetooth LE.
  unsupported,

  /// Not reported yet (iOS while its permission prompt is open, or CoreBluetooth resetting).
  notReady,
}

/// Bluetooth cannot be used right now; [reason] says why.
final class BluetoothUnavailable extends StartScanResult {
  /// Creates the result.
  const BluetoothUnavailable([this.reason = BluetoothUnavailableReason.off]);

  /// Why Bluetooth cannot be used.
  final BluetoothUnavailableReason reason;
}

/// Starting failed unexpectedly.
final class StartFailed extends StartScanResult {
  /// Creates the result with the platform [reason].
  const StartFailed(this.reason);

  /// Platform message.
  final String reason;
}
