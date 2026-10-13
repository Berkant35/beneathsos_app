import 'dart:async';

import 'package:beneathsos_app/core/beacon/domain/beacon_payload.dart';
import 'package:beneathsos_app/core/beacon/domain/beacon_ports.dart';
import 'package:beneathsos_app/core/models/ble_sample.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_ports.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';
import 'package:ble_scanner/ble_scanner.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ble_service.g.dart';

/// The only place that talks to `ble_scanner`. Implements the scanning domain's [ScannerPort] and
/// victim mode's [BeaconPort].
class BleService implements ScannerPort, BeaconPort {
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

  @override
  Stream<void> get advertiseStarted => _scanner.advertiseStarted;

  @override
  Stream<String> get advertiseErrors =>
      _scanner.advertiseErrors.map((e) => e.toString());

  @override
  Future<bool> supported() async =>
      (await _scanner.capabilities()).advertisingSupported;

  /// iOS sends the local name, Android the service data (each ignores the other).
  @override
  Future<void> advertise(BeaconPayload payload) => _scanner.startAdvertising(
    serviceUuid: beaconServiceUuid,
    localName: payload.localName,
    serviceData: payload.encode(),
  );

  @override
  Future<void> stopAdvertising() => _scanner.stopAdvertising();

  /// Releases the plugin.
  Future<void> dispose() => _scanner.dispose();

  /// A victim beacon is keyed by its beacon id, so its rotating address does not split it.
  static BleSample _toSample(ScanSample s) => BleSample(
    key:
        beaconKey(
          serviceUuids: s.serviceUuids,
          serviceData: s.serviceData,
          localName: s.localName,
        ) ??
        s.peripheralKey,
    rssi: s.rssi,
    companyId: s.companyId,
    payload: s.manufacturerData,
    serviceUuids: s.serviceUuids,
    serviceData: s.serviceData,
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

/// The victim beacon (the same plugin instance as scanning).
@Riverpod(keepAlive: true)
BeaconPort beaconPort(Ref ref) => ref.watch(bleServiceProvider);
