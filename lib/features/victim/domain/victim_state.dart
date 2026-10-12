import 'package:beneathsos_app/core/beacon/domain/beacon_payload.dart';

/// Where victim mode stands.
sealed class VictimState {
  const VictimState();
}

/// Starting the beacon.
final class VictimStarting extends VictimState {
  /// Creates the state.
  const VictimStarting();
}

/// Calling out with [payload] (what rescuers receive).
final class VictimCallingOut extends VictimState {
  /// Creates the state.
  const VictimCallingOut(this.payload);

  /// The last payload sent.
  final BeaconPayload payload;
}

/// Bluetooth access is missing; [permanently] when only Settings can grant it.
final class VictimNeedsPermission extends VictimState {
  /// Creates the state.
  const VictimNeedsPermission({required this.permanently});

  /// Only the OS settings can grant it.
  final bool permanently;
}

/// Bluetooth is off; calling out starts as soon as it is on.
final class VictimBluetoothOff extends VictimState {
  /// Creates the state.
  const VictimBluetoothOff();
}

/// This phone cannot advertise (the SOS sound still works).
final class VictimUnsupported extends VictimState {
  /// Creates the state.
  const VictimUnsupported();
}

/// The platform stopped the signal.
final class VictimFailed extends VictimState {
  /// Creates the state.
  const VictimFailed();
}
