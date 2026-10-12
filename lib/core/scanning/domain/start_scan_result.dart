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

/// Bluetooth is off ([unsupported] false) or the device has no Bluetooth LE ([unsupported] true).
final class BluetoothUnavailable extends StartScanResult {
  /// Creates the result.
  const BluetoothUnavailable({this.unsupported = false});

  /// Whether the device cannot do Bluetooth LE at all.
  final bool unsupported;
}

/// Starting failed unexpectedly.
final class StartFailed extends StartScanResult {
  /// Creates the result with the platform [reason].
  const StartFailed(this.reason);

  /// Platform message.
  final String reason;
}
