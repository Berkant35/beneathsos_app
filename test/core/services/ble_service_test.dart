import 'dart:async';
import 'dart:typed_data';

import 'package:beneathsos_app/core/beacon/domain/beacon_payload.dart';
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

  final batches = StreamController<List<ScanSample>>.broadcast();
  final adverts = <(String, String?, Uint8List?)>[];

  @override
  Stream<List<ScanSample>> get samples => batches.stream;

  @override
  Future<void> startAdvertising({
    required String serviceUuid,
    String? localName,
    Uint8List? serviceData,
  }) async => adverts.add((serviceUuid, localName, serviceData));

  Future<void> close() async {
    await states.close();
    await batches.close();
  }
}

ScanSample _sample(
  String key, {
  List<String> uuids = const [],
  Map<String, Uint8List>? data,
  String? name,
}) => ScanSample(
  peripheralKey: key,
  rssi: -70,
  serviceUuids: uuids,
  serviceData: data,
  localName: name,
  monotonicNanos: 1,
  wallClockMillis: 2,
);

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

  test(
    'the beacon sends its UUID, the name for iOS and the data for Android',
    () async {
      await BleService(plugin).advertise(
        const BeaconPayload(
          id: 0x1a2b,
          batteryPercent: 80,
          sinceTouch: Duration.zero,
        ),
      );
      expect(plugin.adverts.single.$1, beaconServiceUuid);
      expect(plugin.adverts.single.$2, 'SOS-1A2B');
      expect(plugin.adverts.single.$3, [1, 0x1a, 0x2b, 80, 0]);
    },
  );

  test('a victim beacon keeps one key while its address rotates', () async {
    final keys = expectLater(
      BleService(plugin).samples.map((b) => [for (final s in b) s.key]),
      emits(['sos-1a2b', 'sos-1a2b', 'AA:BB']),
    );
    final data = Uint8List.fromList([1, 0x1a, 0x2b, 80, 0]);
    plugin.batches.add([
      _sample(
        '11:11',
        uuids: [beaconServiceUuid],
        data: {beaconServiceUuid: data},
      ),
      _sample(
        '22:22',
        uuids: [beaconServiceUuid.toUpperCase()],
        name: 'SOS-1A2B',
      ),
      _sample('AA:BB'),
    ]);
    await keys;
  });
}
