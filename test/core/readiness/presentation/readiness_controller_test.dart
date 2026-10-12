import 'dart:async';

import 'package:beneathsos_app/core/readiness/domain/device_readiness.dart';
import 'package:beneathsos_app/core/readiness/presentation/providers/readiness_controller.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';
import 'package:beneathsos_app/core/scanning/presentation/providers/scanning_providers.dart';
import 'package:beneathsos_app/core/services/app_lifecycle.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../scanning/fakes.dart';

/// Scanner whose availability answers wait for the test (to model slow, overlapping checks).
class _SlowScanner extends FakeScanner {
  final pending = <Completer<BluetoothAvailability>>[];

  @override
  Future<BluetoothAvailability> settledAvailability() {
    final answer = Completer<BluetoothAvailability>();
    pending.add(answer);
    return answer.future;
  }
}

/// Permissions whose check fails like a platform error.
class _BrokenPermissions extends FakePermissions {
  _BrokenPermissions() : super(checkResult: ScanPermission.granted);

  bool broken = true;

  @override
  Future<ScanPermission> check() async {
    calls.add('check');
    if (broken) throw Exception('platform error');
    return checkResult;
  }
}

/// Permissions whose request waits for the test (a system dialog that is still open).
class _SlowRequestPermissions extends FakePermissions {
  _SlowRequestPermissions()
    : super(
        checkResult: ScanPermission.denied,
        requestResult: ScanPermission.denied,
      );

  final pending = <Completer<ScanPermission>>[];

  @override
  Future<ScanPermission> request() {
    calls.add('request');
    final answer = Completer<ScanPermission>();
    pending.add(answer);
    return answer.future;
  }
}

void main() {
  late FakeScanner scanner;
  late FakePermissions permissions;
  late StreamController<AppLifecycleState> lifecycle;
  late ProviderContainer container;

  void start(FakeScanner withScanner) {
    scanner = withScanner;
    container = ProviderContainer(
      overrides: [
        scannerPortProvider.overrideWithValue(scanner),
        scanPermissionPortProvider.overrideWithValue(permissions),
        appLifecycleProvider.overrideWith((ref) => lifecycle.stream),
      ],
    );
    // Riverpod 3 pauses unwatched providers; keep a listener like the home banner does.
    container.listen(readinessControllerProvider, (_, _) {});
  }

  setUp(() {
    permissions = FakePermissions(checkResult: ScanPermission.granted);
    lifecycle = StreamController<AppLifecycleState>();
  });

  tearDown(() async {
    container.dispose();
    await lifecycle.close();
    await scanner.close();
  });

  DeviceReadiness state() => container.read(readinessControllerProvider);

  test('starts as checking, then ready; never scans', () async {
    start(FakeScanner());
    expect(state(), isA<ReadinessChecking>());
    await pumpEventQueue();
    expect(state(), isA<ReadinessReady>());
    expect(scanner.calls, isEmpty);
  });

  test('Bluetooth switched off and on changes the state', () async {
    start(FakeScanner());
    await pumpEventQueue();
    scanner.emitAvailability(BluetoothAvailability.off);
    await pumpEventQueue();
    expect(state(), isA<ReadinessBluetoothOff>());
    scanner.emitAvailability(BluetoothAvailability.on);
    await pumpEventQueue();
    expect(state(), isA<ReadinessReady>());
  });

  test(
    'asks at most once per session: resume after a denial does not ask again',
    () async {
      permissions
        ..checkResult = ScanPermission.denied
        ..requestResult = ScanPermission.denied;
      start(FakeScanner());
      await pumpEventQueue();
      expect(state(), isA<ReadinessNeedsPermission>());
      lifecycle.add(
        AppLifecycleState.resumed,
      ); // the dialog closing resumes the app on Android
      await pumpEventQueue();
      expect(permissions.calls.where((c) => c == 'request'), hasLength(1));
    },
  );

  test('resume re-checks when blocked (back from Settings)', () async {
    start(FakeScanner()..availability = BluetoothAvailability.off);
    await pumpEventQueue();
    expect(state(), isA<ReadinessBluetoothOff>());
    scanner.availability =
        BluetoothAvailability.on; // turned on in Settings, no event seen
    lifecycle.add(AppLifecycleState.resumed);
    await pumpEventQueue();
    expect(state(), isA<ReadinessReady>());
  });

  test('resume does nothing when ready', () async {
    start(FakeScanner());
    await pumpEventQueue();
    final checks = permissions.calls.length;
    lifecycle.add(AppLifecycleState.resumed);
    await pumpEventQueue();
    expect(permissions.calls, hasLength(checks));
  });

  test('requestPermission asks, then re-checks', () async {
    permissions
      ..checkResult = ScanPermission.denied
      ..requestResult = ScanPermission.denied;
    start(FakeScanner());
    await pumpEventQueue();
    permissions
      ..requestResult = ScanPermission.granted
      ..checkResult = ScanPermission.granted;
    await container
        .read(readinessControllerProvider.notifier)
        .requestPermission();
    expect(state(), isA<ReadinessReady>());
    expect(permissions.calls.where((c) => c == 'request'), hasLength(2));
  });

  test('openSettings opens the system settings', () async {
    start(FakeScanner());
    await pumpEventQueue();
    await container.read(readinessControllerProvider.notifier).openSettings();
    expect(permissions.calls, contains('openSettings'));
  });

  test('latest re-check wins when checks overlap (rapid toggling)', () async {
    final slow = _SlowScanner();
    start(slow);
    await pumpEventQueue();
    slow.pending
        .removeAt(0)
        .complete(BluetoothAvailability.on); // initial check
    await pumpEventQueue();
    final notifier = container.read(readinessControllerProvider.notifier);
    unawaited(notifier.recheck()); // older: will answer "off" last
    unawaited(notifier.recheck()); // newer: answers "on" first
    await pumpEventQueue();
    slow.pending[1].complete(BluetoothAvailability.on);
    await pumpEventQueue();
    slow.pending[0].complete(BluetoothAvailability.off);
    await pumpEventQueue();
    expect(state(), isA<ReadinessReady>());
  });

  test(
    'a failing port shows "could not check" instead of hanging on checking',
    () async {
      permissions = _BrokenPermissions();
      start(FakeScanner());
      await pumpEventQueue();
      expect(state(), isA<ReadinessFailed>());
    },
  );

  test('after a failure, resume re-checks', () async {
    final broken = _BrokenPermissions();
    permissions = broken;
    start(FakeScanner());
    await pumpEventQueue();
    broken.broken = false;
    lifecycle.add(AppLifecycleState.resumed);
    await pumpEventQueue();
    expect(state(), isA<ReadinessReady>());
  });

  test(
    'a second tap while the permission dialog is open does not ask twice',
    () async {
      final slow = _SlowRequestPermissions();
      permissions = slow;
      start(FakeScanner());
      await pumpEventQueue();
      slow.pending
          .removeAt(0)
          .complete(ScanPermission.denied); // the launch request
      await pumpEventQueue();
      final notifier = container.read(readinessControllerProvider.notifier);
      unawaited(notifier.requestPermission());
      unawaited(notifier.requestPermission()); // gloved double tap
      await pumpEventQueue();
      expect(
        slow.calls.where((c) => c == 'request'),
        hasLength(2),
      ); // launch + one tap
      slow.pending.single.complete(ScanPermission.denied);
      await pumpEventQueue();
    },
  );
}
