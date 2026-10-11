/// Bluetooth adapter availability as the domain sees it.
enum BluetoothAvailability {
  /// Not reported yet (iOS before CoreBluetooth is ready).
  unknown,

  /// The device has no Bluetooth LE.
  unsupported,

  /// The user denied Bluetooth access (iOS).
  unauthorized,

  /// Bluetooth is turned off.
  off,

  /// Bluetooth is on.
  on,
}

/// Runtime permission state needed for scanning.
enum ScanPermission {
  /// Everything needed is granted.
  granted,

  /// Missing, but the user can still be asked.
  denied,

  /// Missing and only the OS settings can grant it.
  permanentlyDenied,
}
