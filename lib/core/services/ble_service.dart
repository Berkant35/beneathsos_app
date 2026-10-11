import 'dart:async';

import 'package:beneathsos_app/core/models/ble_sample.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_ports.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';
import 'package:ble_scanner/ble_scanner.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ble_service.g.dart';

/// The only place that talks to `ble_scanner`. Implements the scanning domain's [ScannerPort].
class BleService implements ScannerPort {
  /// Wraps [scanner]. [settleTimeout] bounds the wait for a definitive adapter state.
  BleService(this._scanner, {this.settleTimeout = const Duration(seconds: 3)});

  final BleScanner _scanner;

  /// How long [settledAvailability] waits while the platform reports `unknown`.
  final Duration settleTimeout;

  /// Batches of received advertisements.
  Stream<List<BleSample>> get samples =>
      _scanner.samples.map((batch) => batch.map(_toSample).toList());

  @override
  Stream<BluetoothAvailability> get availabilityChanges =>
      _scanner.adapterStates.map(_toAvailability);

  @override
  Stream<String> get errors => _scanner.errors.map((e) => e.toString());

  /// iOS reports `unknown` until CoreBluetooth is ready (creating the manager is what
  /// triggers it), so wait briefly for the real state before deciding anything.
  @override
  Future<BluetoothAvailability> settledAvailability() async {
    final current = _toAvailability(await _scanner.adapterState());
    if (current != BluetoothAvailability.unknown) return current;
    return availabilityChanges
        .firstWhere((a) => a != BluetoothAvailability.unknown)
        .timeout(settleTimeout, onTimeout: () => BluetoothAvailability.unknown);
  }

  /// Starts a low-latency scan suitable for RSSI measurements.
  @override
  Future<void> start() => _scanner.start();

  @override
  Future<void> stop() => _scanner.stop();

  /// Releases the plugin.
  Future<void> dispose() => _scanner.dispose();

  static BleSample _toSample(ScanSample s) => BleSample(
    key: s.peripheralKey,
    rssi: s.rssi,
    companyId: s.companyId,
    payload: s.manufacturerData,
    serviceUuids: s.serviceUuids,
    localName: s.localName,
    txPower: s.txPower,
    monotonicNanos: s.monotonicNanos,
    wallClockMillis: s.wallClockMillis,
  );

  static BluetoothAvailability _toAvailability(AdapterState s) => switch (s) {
    AdapterState.unknown => BluetoothAvailability.unknown,
    AdapterState.unsupported => BluetoothAvailability.unsupported,
    AdapterState.unauthorized => BluetoothAvailability.unauthorized,
    AdapterState.poweredOff => BluetoothAvailability.off,
    AdapterState.poweredOn => BluetoothAvailability.on,
  };
}

/// App-wide BLE service.
@Riverpod(keepAlive: true)
BleService bleService(Ref ref) {
  final service = BleService(BleScanner());
  ref.onDispose(() => unawaited(service.dispose()));
  return service;
}

/// Stream of sample batches.
@Riverpod(keepAlive: true)
Stream<List<BleSample>> bleSamples(Ref ref) =>
    ref.watch(bleServiceProvider).samples;
