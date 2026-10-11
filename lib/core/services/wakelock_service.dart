import 'package:beneathsos_app/core/scanning/domain/scan_ports.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

part 'wakelock_service.g.dart';

/// Keeps the screen on while measuring (iOS scans only in the foreground).
/// Implements [ScreenAwakePort].
class WakelockService implements ScreenAwakePort {
  @override
  Future<void> keepAwake({required bool enabled}) =>
      WakelockPlus.toggle(enable: enabled);
}

/// App-wide wakelock service.
@Riverpod(keepAlive: true)
WakelockService wakelockService(Ref ref) => WakelockService();
