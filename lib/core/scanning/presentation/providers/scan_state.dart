/// Scanner state shown to the user.
sealed class ScanState {
  const ScanState();
}

/// Not scanning.
final class ScanIdle extends ScanState {
  /// Creates the idle state.
  const ScanIdle();
}

/// A permission is missing; [permanent] means only OS settings can fix it.
final class ScanNeedsPermission extends ScanState {
  /// Creates the state.
  const ScanNeedsPermission({required this.permanent});

  /// Whether the user must go to OS settings.
  final bool permanent;
}

/// Bluetooth is off or unsupported.
final class ScanBluetoothOff extends ScanState {
  /// Creates the state.
  const ScanBluetoothOff();
}

/// Scanning since [since].
final class ScanRunning extends ScanState {
  /// Creates the state.
  const ScanRunning(this.since);

  /// Start time.
  final DateTime since;
}

/// Starting failed or the platform reported a scan error.
final class ScanFailed extends ScanState {
  /// Creates the state.
  const ScanFailed(this.reason);

  /// Platform message.
  final String reason;
}
