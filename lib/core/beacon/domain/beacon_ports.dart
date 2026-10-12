import 'package:beneathsos_app/core/beacon/domain/beacon_payload.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';

/// What victim mode needs from the Bluetooth radio. Implemented in `core/services`.
abstract interface class BeaconPort {
  /// The definitive adapter state (iOS reports `unknown` briefly at first).
  Future<BluetoothAvailability> settledAvailability();

  /// Adapter state changes while the app runs.
  Stream<BluetoothAvailability> get availabilityChanges;

  /// Advertising failures reported by the platform, as text.
  Stream<String> get advertiseErrors;

  /// Whether this phone can advertise at all.
  Future<bool> supported();

  /// Starts calling out with [payload], or replaces the payload.
  Future<void> advertise(BeaconPayload payload);

  /// Stops calling out.
  Future<void> stopAdvertising();
}

/// The phone's battery.
abstract interface class BatteryPort {
  /// Battery level in %, or null when the platform does not tell.
  Future<int?> level();
}

/// The loud SOS sound a rescuer's ear can follow.
abstract interface class SosSoundPort {
  /// Plays the sound in a loop until [stop].
  Future<void> play();

  /// Stops the sound.
  Future<void> stop();
}
