import 'dart:async';

import 'package:beneathsos_app/core/models/ble_sample.dart';
import 'package:ble_scanner/ble_scanner.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ble_service.g.dart';

/// Bluetooth adapter availability, independent of the plugin enum.
enum BluetoothAvailability { unknown, unsupported, unauthorized, off, on }

/// The only place that talks to `ble_scanner`. Features use this service's providers.
class BleService {
  /// Wraps [scanner].
  BleService(this._scanner);

  final BleScanner _scanner;

  /// Batches of received advertisements.
  Stream<List<BleSample>> get samples =>
      _scanner.samples.map((batch) => batch.map(_toSample).toList());

  /// Adapter availability changes.
  Stream<BluetoothAvailability> get availabilityChanges =>
      _scanner.adapterStates.map(_toAvailability);

  /// Asynchronous scan failures as text.
  Stream<String> get errors => _scanner.errors.map((e) => e.toString());

  /// Current adapter availability.
  Future<BluetoothAvailability> availability() async =>
      _toAvailability(await _scanner.adapterState());

  /// Starts a low-latency scan suitable for RSSI measurements.
  Future<void> start() => _scanner.start();

  /// Stops scanning.
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
