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

/// The phone has no Bluetooth LE.
final class ReadinessUnsupported extends DeviceReadiness {
  /// Creates the state.
  const ReadinessUnsupported();
}
