import 'package:beneathsos_app/core/scanning/domain/scan_preconditions.dart';
import 'package:beneathsos_app/core/scanning/domain/start_scan.dart';
import 'package:beneathsos_app/core/scanning/domain/start_scan_result.dart';
import 'package:beneathsos_app/core/scanning/domain/stop_scan.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes.dart';

/// Precondition with a fixed answer that records that it ran.
class _Fixed implements ScanPrecondition {
  _Fixed(this.result, this.log, this.name);

  final StartScanResult? result;
  final List<String> log;
  final String name;

  @override
  Future<StartScanResult?> check() async {
    log.add(name);
    return result;
  }
}

void main() {
  late FakeScanner scanner;
  late FakeScreen screen;

  setUp(() {
    scanner = FakeScanner();
    screen = FakeScreen();
  });

  StartScan startScan(List<ScanPrecondition> preconditions) =>
      StartScan(preconditions: preconditions, scanner: scanner, screen: screen);

  test(
    'starts and keeps the screen awake when every precondition passes',
    () async {
      final log = <String>[];

      final result = await startScan([
        _Fixed(null, log, 'a'),
        _Fixed(null, log, 'b'),
      ])();

      expect(result, isA<ScanStarted>());
      expect(log, ['a', 'b']);
      expect(scanner.calls, ['start']);
      expect(screen.changes, [true]);
    },
  );

  test('stops at the first blocking precondition and does not start', () async {
    final log = <String>[];

    final result = await startScan([
      _Fixed(const BluetoothUnavailable(), log, 'bluetooth'),
      _Fixed(null, log, 'never'),
    ])();

    expect(result, isA<BluetoothUnavailable>());
    expect(log, ['bluetooth']);
    expect(scanner.calls, isEmpty);
    expect(screen.changes, isEmpty);
  });

  test('reports a platform failure instead of throwing', () async {
    scanner.startError = Exception('adapter busy');

    final result = await startScan(const [])();

    expect(
      result,
      isA<StartFailed>().having(
        (r) => r.reason,
        'reason',
        contains('adapter busy'),
      ),
    );
    expect(screen.changes, isEmpty);
  });

  test('StopScan stops the scanner and lets the screen sleep', () async {
    await StopScan(scanner: scanner, screen: screen)();

    expect(scanner.calls, ['stop']);
    expect(screen.changes, [false]);
  });
}
