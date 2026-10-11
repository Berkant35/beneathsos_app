import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';

/// What the scanner is doing, as far as adapter changes are concerned.
enum ScanActivity {
  /// Not scanning and not blocked.
  idle,

  /// Scanning.
  scanning,

  /// Blocked because Bluetooth is off or unavailable.
  waitingForBluetooth,

  /// Blocked by a missing permission.
  waitingForPermission,

  /// The last attempt failed.
  failed,
}

/// Reaction to an adapter change.
enum AvailabilityReaction {
  /// Nothing to do.
  none,

  /// Show that Bluetooth is off.
  markBluetoothUnavailable,

  /// Show that the Bluetooth permission is missing (only fixable in OS settings).
  markPermissionMissing,

  /// Bluetooth came back: start scanning again.
  restart,
}

/// Decides how to react when the adapter state changes. Pure function.
AvailabilityReaction reactToAvailability(
  BluetoothAvailability availability,
  ScanActivity activity,
) => switch (availability) {
  BluetoothAvailability.off || BluetoothAvailability.unsupported =>
    activity == ScanActivity.scanning
        ? AvailabilityReaction.markBluetoothUnavailable
        : AvailabilityReaction.none,
  BluetoothAvailability.unauthorized =>
    AvailabilityReaction.markPermissionMissing,
  BluetoothAvailability.on =>
    activity == ScanActivity.waitingForBluetooth
        ? AvailabilityReaction.restart
        : AvailabilityReaction.none,
  BluetoothAvailability.unknown => AvailabilityReaction.none,
};
