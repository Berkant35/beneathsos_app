import 'dart:async';

import 'package:beneathsos_app/core/scanning/domain/availability_policy.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';
import 'package:beneathsos_app/core/scanning/domain/start_scan_result.dart';
import 'package:beneathsos_app/core/scanning/presentation/providers/scan_state.dart';
import 'package:beneathsos_app/core/scanning/presentation/providers/scanning_providers.dart';
import 'package:beneathsos_app/core/services/app_lifecycle.dart';
import 'package:beneathsos_app/core/services/clock.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scan_controller.g.dart';

/// Scanner state for the UI. Thin: calls use cases, maps results, wires streams.
/// Rules live in `core/scanning/domain`.
@Riverpod(keepAlive: true)
class ScanController extends _$ScanController {
  @override
  ScanState build() {
    final scanner = ref.watch(scannerPortProvider);
    final errors = scanner.errors.listen((e) => state = ScanFailed(e));
    final availability = scanner.availabilityChanges.listen(_onAvailability);
    ref.listen(appLifecycleProvider, (_, next) {
      if (next.value == AppLifecycleState.resumed) _recheckIfBlocked();
    });
    ref.onDispose(() {
      unawaited(errors.cancel());
      unawaited(availability.cancel());
    });
    return const ScanIdle();
  }

  /// Checks preconditions and starts scanning.
  Future<void> start() async {
    final result = await ref.read(startScanProvider)();
    state = switch (result) {
      ScanStarted() => ScanRunning(ref.read(clockProvider)()),
      PermissionMissing(:final permanent) => ScanNeedsPermission(
        permanent: permanent,
      ),
      BluetoothUnavailable() => const ScanBluetoothOff(),
      StartFailed(:final reason) => ScanFailed(reason),
    };
  }

  /// Stops scanning.
  Future<void> stop() async {
    await ref.read(stopScanProvider)();
    state = const ScanIdle();
  }

  /// Opens OS settings for permissions.
  Future<void> openSettings() =>
      ref.read(scanPermissionPortProvider).openSettings();

  void _onAvailability(BluetoothAvailability availability) {
    switch (reactToAvailability(availability, _activity)) {
      case AvailabilityReaction.markBluetoothUnavailable:
        state = const ScanBluetoothOff();
      case AvailabilityReaction.markPermissionMissing:
        state = const ScanNeedsPermission(permanent: true);
      case AvailabilityReaction.restart:
        unawaited(start());
      case AvailabilityReaction.none:
        break;
    }
  }

  /// After returning to the app (e.g. from Settings), retry only when blocked.
  void _recheckIfBlocked() {
    if (_activity == ScanActivity.waitingForPermission ||
        _activity == ScanActivity.waitingForBluetooth) {
      unawaited(start());
    }
  }

  ScanActivity get _activity => switch (state) {
    ScanIdle() => ScanActivity.idle,
    ScanRunning() => ScanActivity.scanning,
    ScanBluetoothOff() => ScanActivity.waitingForBluetooth,
    ScanNeedsPermission() => ScanActivity.waitingForPermission,
    ScanFailed() => ScanActivity.failed,
  };
}
