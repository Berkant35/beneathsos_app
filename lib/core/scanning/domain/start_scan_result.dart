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

/// Bluetooth is off or not available on this device.
final class BluetoothUnavailable extends StartScanResult {
  /// Creates the result.
  const BluetoothUnavailable();
}

/// Starting failed unexpectedly.
final class StartFailed extends StartScanResult {
  /// Creates the result with the platform [reason].
  const StartFailed(this.reason);

  /// Platform message.
  final String reason;
}
