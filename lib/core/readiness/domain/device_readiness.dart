/// Can this phone search right now? Shown on the home screen; never starts a scan.
sealed class DeviceReadiness {
  const DeviceReadiness();
}

/// Not known yet.
final class ReadinessChecking extends DeviceReadiness {
  /// Creates the state.
  const ReadinessChecking();
}

/// Permission granted and Bluetooth on.
final class ReadinessReady extends DeviceReadiness {
  /// Creates the state.
  const ReadinessReady();
}

/// Permission missing; the app can ask.
final class ReadinessNeedsPermission extends DeviceReadiness {
  /// Creates the state.
  const ReadinessNeedsPermission();
}

/// Permission missing; only the system settings can grant it.
final class ReadinessPermissionInSettings extends DeviceReadiness {
  /// Creates the state.
  const ReadinessPermissionInSettings();
}

/// Bluetooth is off.
final class ReadinessBluetoothOff extends DeviceReadiness {
  /// Creates the state.
  const ReadinessBluetoothOff();
}

/// Checking failed (a platform error); the user can try again.
final class ReadinessFailed extends DeviceReadiness {
  /// Creates the state.
  const ReadinessFailed();
}

/// The phone has no Bluetooth LE.
final class ReadinessUnsupported extends DeviceReadiness {
  /// Creates the state.
  const ReadinessUnsupported();
}
