import 'package:beneathsos_app/core/scanning/domain/scan_ports.dart';

/// Use case: stop scanning and let the screen sleep again.
final class StopScan {
  /// Creates the use case.
  const StopScan({required this._scanner, required this._screen});

  final ScannerPort _scanner;
  final ScreenAwakePort _screen;

  /// Runs the use case.
  Future<void> call() async {
    await _scanner.stop();
    await _screen.keepAwake(enabled: false);
  }
}
