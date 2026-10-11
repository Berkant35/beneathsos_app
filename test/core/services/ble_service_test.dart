import 'dart:async';

import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';
import 'package:beneathsos_app/core/services/ble_service.dart';
import 'package:ble_scanner/ble_scanner.dart';
import 'package:flutter_test/flutter_test.dart';

/// Plugin stand-in: only the members BleService uses for availability are implemented.
class _FakeBleScanner extends Fake implements BleScanner {
  AdapterState current = AdapterState.unknown;
  final states = StreamController<AdapterState>.broadcast();

  @override
  Future<AdapterState> adapterState() async => current;

  @override
  Stream<AdapterState> get adapterStates => states.stream;

  Future<void> close() => states.close();
}

void main() {
  late _FakeBleScanner plugin;

  setUp(() => plugin = _FakeBleScanner());
  tearDown(() => plugin.close());

  test('returns the current state immediately when it is known', () async {
    plugin.current = AdapterState.poweredOn;

    expect(
      await BleService(plugin).settledAvailability(),
      BluetoothAvailability.on,
    );
  });

  test('iOS: waits past "unknown" for the first real state', () async {
    final result = BleService(plugin).settledAvailability();
    await pumpEventQueue();
    plugin.states
      ..add(AdapterState.unknown)
      ..add(AdapterState.unsupported);

    expect(await result, BluetoothAvailability.unsupported);
  });

  test('gives up after the settle timeout and reports unknown', () async {
    final service = BleService(
      plugin,
      settleTimeout: const Duration(milliseconds: 20),
    );

    expect(await service.settledAvailability(), BluetoothAvailability.unknown);
  });
}
