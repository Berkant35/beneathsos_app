import 'dart:async';

import 'package:beneathsos_app/core/beacon/domain/beacon_payload.dart';
import 'package:beneathsos_app/core/beacon/domain/beacon_ports.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';

import '../scanning/fakes.dart';

/// A beacon radio that records what it was asked to send.
final class FakeBeacon implements BeaconPort {
  FakeBeacon({
    this.availability = BluetoothAvailability.on,
    this.canAdvertise = true,
  });

  BluetoothAvailability availability;
  bool canAdvertise;
  final sent = <BeaconPayload>[];
  int stopped = 0;
  final _availability = StreamController<BluetoothAvailability>.broadcast();
  final _errors = StreamController<String>.broadcast();

  @override
  Future<BluetoothAvailability> settledAvailability() async => availability;

  @override
  Stream<BluetoothAvailability> get availabilityChanges => _availability.stream;

  @override
  Stream<String> get advertiseErrors => _errors.stream;

  @override
  Future<bool> supported() async => canAdvertise;

  @override
  Future<void> advertise(BeaconPayload payload) async => sent.add(payload);

  @override
  Future<void> stopAdvertising() async => stopped++;

  /// Bluetooth changed.
  void turn(BluetoothAvailability to) {
    availability = to;
    _availability.add(to);
  }

  /// The platform reports a failure.
  void fail(String message) => _errors.add(message);
}

/// A battery at [level] %.
final class FakeBattery implements BatteryPort {
  FakeBattery([this.level_]);

  int? level_;

  @override
  Future<int?> level() async => level_;
}

/// Records whether the SOS sound plays.
final class FakeSound implements SosSoundPort {
  bool playing = false;

  @override
  Future<void> play() async => playing = true;

  @override
  Future<void> stop() async => playing = false;
}

/// Everything victim mode talks to, with a clock the test moves.
final class BeaconFakes {
  BeaconFakes({
    FakeBeacon? beacon,
    FakePermissions? permissions,
    FakeBattery? battery,
    FakeSound? sound,
  }) : beacon = beacon ?? FakeBeacon(),
       permissions =
           permissions ?? FakePermissions(checkResult: ScanPermission.granted),
       battery = battery ?? FakeBattery(80),
       sound = sound ?? FakeSound();

  final FakeBeacon beacon;
  final FakePermissions permissions;
  final FakeBattery battery;
  final FakeSound sound;

  /// The wall clock victim mode reads.
  DateTime now = DateTime(2026, 10, 13, 3);
}
