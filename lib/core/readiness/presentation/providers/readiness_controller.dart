import 'dart:async';

import 'package:beneathsos_app/core/logging/app_logger.dart';
import 'package:beneathsos_app/core/readiness/domain/check_readiness.dart';
import 'package:beneathsos_app/core/readiness/domain/device_readiness.dart';
import 'package:beneathsos_app/core/scanning/presentation/providers/scanning_providers.dart';
import 'package:beneathsos_app/core/services/app_lifecycle.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'readiness_controller.g.dart';

const _tag = 'readiness';

/// The readiness use case, bound to the app's ports.
@Riverpod(keepAlive: true)
CheckReadiness checkReadiness(Ref ref) => CheckReadiness(
  permissions: ref.watch(scanPermissionPortProvider),
  scanner: ref.watch(scannerPortProvider),
);

/// Device readiness for the home banner. Thin: runs the use case, re-checks on Bluetooth changes
/// and on resume when blocked. Asks for permission automatically once per session; never scans.
@Riverpod(keepAlive: true)
class ReadinessController extends _$ReadinessController {
  int _generation = 0;

  // One system dialog at a time: a second request while one is open throws on Android.
  bool _requesting = false;

  @override
  DeviceReadiness build() {
    final changes = ref
        .watch(scannerPortProvider)
        .availabilityChanges
        .listen((_) => unawaited(recheck()));
    ref.listen(appLifecycleProvider, (_, next) {
      if (next.value == AppLifecycleState.resumed && _blocked) {
        unawaited(recheck());
      }
    });
    ref.onDispose(() => unawaited(changes.cancel()));
    unawaited(_check(askForPermission: true));
    return const ReadinessChecking();
  }

  bool get _blocked => switch (state) {
    ReadinessChecking() || ReadinessReady() => false,
    _ => true,
  };

  /// Checks again without asking for permission.
  Future<void> recheck() => _check(askForPermission: false);

  /// Asks for the missing permission (user tapped the banner), then re-checks. A tap while the
  /// dialog is still open is ignored.
  Future<void> requestPermission() async {
    if (_requesting) return;
    _requesting = true;
    try {
      await ref.read(scanPermissionPortProvider).request();
    } on Exception catch (error, stack) {
      AppLogger.error(_tag, 'permission request failed', error, stack);
    } finally {
      _requesting = false;
    }
    await recheck();
  }

  /// Opens the system settings, then re-checks (and again on resume).
  Future<void> openSettings() async {
    try {
      await ref.read(scanPermissionPortProvider).openSettings();
    } on Exception catch (error, stack) {
      AppLogger.error(_tag, 'opening settings failed', error, stack);
    }
    await recheck();
  }

  Future<void> _check({required bool askForPermission}) async {
    final generation = ++_generation;
    DeviceReadiness result;
    try {
      result = await ref.read(checkReadinessProvider)(
        askForPermission: askForPermission,
      );
    } on Exception catch (error, stack) {
      AppLogger.error(_tag, 'readiness check failed', error, stack);
      result = const ReadinessFailed();
    }
    // A newer check is in flight, or the provider is gone: drop this answer.
    if (!ref.mounted || generation != _generation) return;
    state = result;
  }
}
