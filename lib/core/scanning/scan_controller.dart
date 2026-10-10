import 'dart:async';

import 'package:beneathsos_app/core/logging/app_logger.dart';
import 'package:beneathsos_app/core/services/app_lifecycle.dart';
import 'package:beneathsos_app/core/services/ble_service.dart';
import 'package:beneathsos_app/core/services/permission_service.dart';
import 'package:beneathsos_app/core/services/wakelock_service.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scan_controller.g.dart';

/// Scanner lifecycle.
sealed class ScanState {
  const ScanState();
}

/// Not scanning.
final class ScanIdle extends ScanState {
  /// Creates the idle state.
  const ScanIdle();
}

/// Permission missing; [permanent] means only OS settings can fix it.
final class ScanNeedsPermission extends ScanState {
  /// Creates the state.
  const ScanNeedsPermission({required this.permanent});

  /// Whether the user must go to OS settings.
  final bool permanent;
}

/// Bluetooth off or unsupported.
final class ScanBluetoothOff extends ScanState {
  /// Creates the state.
  const ScanBluetoothOff();
}

/// Scanning since [since].
final class ScanRunning extends ScanState {
  /// Creates the state.
  const ScanRunning(this.since);

  /// Start time.
  final DateTime since;
}

/// Scan could not start or failed.
final class ScanFailed extends ScanState {
  /// Creates the state.
  const ScanFailed(this.reason);

  /// Platform message.
  final String reason;
}

/// Starts/stops the scanner and guards permissions and adapter state.
@Riverpod(keepAlive: true)
class ScanController extends _$ScanController {
  static const _tag = 'ScanController';

  /// How long to wait for iOS to report a definitive adapter state after creating the manager.
  static const adapterSettleTimeout = Duration(seconds: 3);

  @override
  ScanState build() {
    final service = ref.watch(bleServiceProvider);
    final errors = service.errors.listen((e) => state = ScanFailed(e));
    final availability = service.availabilityChanges.listen(_onAvailability);
    ref.listen(appLifecycleProvider, (_, next) {
      if (next.value == AppLifecycleState.resumed) _recheckIfBlocked();
    });
    ref.onDispose(() {
      unawaited(errors.cancel());
      unawaited(availability.cancel());
    });
    return const ScanIdle();
  }

  void _onAvailability(BluetoothAvailability availability) {
    switch (availability) {
      case BluetoothAvailability.off || BluetoothAvailability.unsupported:
        if (state is ScanRunning) state = const ScanBluetoothOff();
      case BluetoothAvailability.unauthorized:
        state = const ScanNeedsPermission(permanent: true);
      case BluetoothAvailability.on:
        if (state is ScanBluetoothOff) unawaited(start());
      case BluetoothAvailability.unknown:
        break;
    }
  }

  /// iOS reports `unknown` until CoreBluetooth is ready; wait briefly for the real state.
  Future<BluetoothAvailability> _settledAvailability(BleService service) async {
    final current = await service.availability();
    if (current != BluetoothAvailability.unknown) return current;
    return service.availabilityChanges
        .firstWhere((a) => a != BluetoothAvailability.unknown)
        .timeout(
          adapterSettleTimeout,
          onTimeout: () => BluetoothAvailability.unknown,
        );
  }

  /// Checks permissions and adapter, then starts scanning.
  Future<void> start() async {
    final permissions = ref.read(permissionServiceProvider);
    var permission = await permissions.check();
    if (permission == ScanPermission.denied) {
      permission = await permissions.request();
    }
    if (permission != ScanPermission.granted) {
      state = ScanNeedsPermission(
        permanent: permission == ScanPermission.permanentlyDenied,
      );
      return;
    }
    final service = ref.read(bleServiceProvider);
    final availability = await _settledAvailability(service);
    if (availability == BluetoothAvailability.unauthorized) {
      state = const ScanNeedsPermission(permanent: true);
      return;
    }
    if (availability == BluetoothAvailability.off ||
        availability == BluetoothAvailability.unsupported) {
      state = const ScanBluetoothOff();
      return;
    }
    try {
      await service.start();
      await ref.read(wakelockServiceProvider).keepAwake(enabled: true);
      state = ScanRunning(DateTime.now());
    } on Exception catch (e, st) {
      AppLogger.error(_tag, 'start failed', e, st);
      state = ScanFailed(e.toString());
    }
  }

  /// Stops scanning.
  Future<void> stop() async {
    await ref.read(bleServiceProvider).stop();
    await ref.read(wakelockServiceProvider).keepAwake(enabled: false);
    state = const ScanIdle();
  }

  /// Opens OS settings for permissions.
  Future<void> openSettings() =>
      ref.read(permissionServiceProvider).openSettings();

  /// After returning to the app (e.g. from Settings), retry only when blocked.
  void _recheckIfBlocked() {
    if (state is ScanNeedsPermission || state is ScanBluetoothOff) {
      unawaited(start());
    }
  }
}
