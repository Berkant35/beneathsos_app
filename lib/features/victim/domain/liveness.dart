import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';
import 'package:beneathsos_app/features/victim/domain/victim_state.dart';

/// When someone last touched or moved the trapped phone — a sign of life rescuers can read.
final class Liveness {
  /// Starts counting at [now].
  Liveness(DateTime now) : _last = now;

  /// After this long without a touch, a touch is news worth sending at once.
  static const quiet = Duration(minutes: 1);

  DateTime _last;

  /// Time since the last touch or movement.
  Duration since(DateTime now) => now.difference(_last);

  /// Records a touch at [now]; true when it ends a quiet minute (send it now).
  bool touch(DateTime now) {
    final wasQuiet = since(now) >= quiet;
    _last = now;
    return wasQuiet;
  }
}

/// What victim mode becomes when the radio reports [availability]: Bluetooth off and access taken
/// away are said at once; null when nothing changes (on → the caller starts again).
VictimState? onRadio(BluetoothAvailability availability) =>
    switch (availability) {
      BluetoothAvailability.off => const VictimBluetoothOff(),
      BluetoothAvailability.unauthorized => const VictimNeedsPermission(
        permanently: true,
      ),
      BluetoothAvailability.unsupported => const VictimUnsupported(),
      BluetoothAvailability.on || BluetoothAvailability.unknown => null,
    };
