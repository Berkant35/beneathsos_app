import 'dart:async';

import 'package:beneathsos_app/core/scanning/domain/scan_ports.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';

/// Scanner whose availability and start behaviour are set by the test; records calls.
/// Adapter changes and platform errors are pushed with [emitAvailability] / [emitError].
class FakeScanner implements ScannerPort {
  BluetoothAvailability availability = BluetoothAvailability.on;
  Exception? startError;

  /// When set, [start] waits for it (a slow platform start).
  Completer<void>? startGate;
  final calls = <String>[];
  final _availability = StreamController<BluetoothAvailability>.broadcast();
  final _errors = StreamController<String>.broadcast();

  void emitAvailability(BluetoothAvailability value) {
    availability = value;
    _availability.add(value);
  }

  void emitError(String message) => _errors.add(message);

  Future<void> close() async {
    await _availability.close();
    await _errors.close();
  }

  @override
  Future<BluetoothAvailability> settledAvailability() async => availability;

  @override
  Stream<BluetoothAvailability> get availabilityChanges => _availability.stream;

  @override
  Stream<String> get errors => _errors.stream;

  @override
  Future<void> start() async {
    calls.add('start');
    await startGate?.future;
    final error = startError;
    if (error != null) throw error;
  }

  @override
  Future<void> stop() async => calls.add('stop');
}

/// Permission system with a scripted answer for check and request; records calls.
class FakePermissions implements ScanPermissionPort {
  FakePermissions({
    required this.checkResult,
    this.requestResult = ScanPermission.granted,
  });

  ScanPermission checkResult;
  ScanPermission requestResult;
  final calls = <String>[];

  @override
  Future<ScanPermission> check() async {
    calls.add('check');
    return checkResult;
  }

  @override
  Future<ScanPermission> request() async {
    calls.add('request');
    return requestResult;
  }

  @override
  Future<void> openSettings() async => calls.add('openSettings');
}

/// Records keep-awake changes.
class FakeScreen implements ScreenAwakePort {
  final changes = <bool>[];

  @override
  Future<void> keepAwake({required bool enabled}) async => changes.add(enabled);
}
