import 'package:beneathsos_app/core/beacon/domain/beacon_payload.dart';
import 'package:beneathsos_app/core/beacon/domain/beacon_ports.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_ports.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';

/// How starting the beacon went.
sealed class BeaconStart {
  const BeaconStart();
}

/// The phone is calling out.
final class BeaconStarted extends BeaconStart {
  /// Creates the result.
  const BeaconStarted();
}

/// Bluetooth access is missing; [permanently] when only Settings can grant it.
final class BeaconNeedsPermission extends BeaconStart {
  /// Creates the result.
  const BeaconNeedsPermission({required this.permanently});

  /// Only the OS settings can grant it.
  final bool permanently;
}

/// Bluetooth is off.
final class BeaconBluetoothOff extends BeaconStart {
  /// Creates the result.
  const BeaconBluetoothOff();
}

/// This phone cannot advertise.
final class BeaconUnsupported extends BeaconStart {
  /// Creates the result.
  const BeaconUnsupported();
}

/// Starts calling out with as few steps as possible for a trapped person: a missing permission is
/// asked for at once.
final class StartBeacon {
  /// Creates the use case over the beacon radio and the advertising permission.
  const StartBeacon(this._beacon, this._permissions);

  final BeaconPort _beacon;
  final ScanPermissionPort _permissions;

  /// Starts with [payload].
  Future<BeaconStart> call(BeaconPayload payload) async {
    var permission = await _permissions.check();
    if (permission == ScanPermission.denied) {
      permission = await _permissions.request();
    }
    if (permission != ScanPermission.granted) {
      return BeaconNeedsPermission(
        permanently: permission == ScanPermission.permanentlyDenied,
      );
    }
    switch (await _beacon.settledAvailability()) {
      case BluetoothAvailability.unsupported:
        return const BeaconUnsupported();
      case BluetoothAvailability.unauthorized:
        return const BeaconNeedsPermission(permanently: true);
      case BluetoothAvailability.off:
        return const BeaconBluetoothOff();
      case BluetoothAvailability.on || BluetoothAvailability.unknown:
        break;
    }
    if (!await _beacon.supported()) return const BeaconUnsupported();
    await _beacon.advertise(payload);
    return const BeaconStarted();
  }
}
