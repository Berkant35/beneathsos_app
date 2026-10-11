import 'package:beneathsos_app/core/scanning/domain/scan_ports.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_preconditions.dart';
import 'package:beneathsos_app/core/scanning/domain/start_scan_result.dart';

/// Use case: check every precondition in order, then start scanning.
final class StartScan {
  /// Creates the use case. [preconditions] run in the given order.
  const StartScan({
    required this._preconditions,
    required this._scanner,
    required this._screen,
  });

  final List<ScanPrecondition> _preconditions;
  final ScannerPort _scanner;
  final ScreenAwakePort _screen;

  /// Runs the use case. Stops at the first precondition that blocks.
  Future<StartScanResult> call() async {
    for (final precondition in _preconditions) {
      final blocked = await precondition.check();
      if (blocked != null) return blocked;
    }
    try {
      await _scanner.start();
      await _screen.keepAwake(enabled: true);
      return const ScanStarted();
    } on Exception catch (e) {
      return StartFailed(e.toString());
    }
  }
}
