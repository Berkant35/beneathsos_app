import 'dart:async';
import 'dart:math';

import 'package:beneathsos_app/core/logging/app_logger.dart';
import 'package:beneathsos_app/core/scanning/presentation/providers/scan_controller.dart';
import 'package:beneathsos_app/core/scanning/presentation/providers/scan_state.dart';
import 'package:beneathsos_app/core/services/app_lifecycle.dart';
import 'package:beneathsos_app/core/services/clock.dart';
import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/features/targets/domain/ambient_state.dart';
import 'package:beneathsos_app/features/targets/domain/candidates.dart';
import 'package:beneathsos_app/features/targets/domain/choice_result.dart';
import 'package:beneathsos_app/features/targets/domain/target_use_cases.dart';
import 'package:beneathsos_app/features/targets/presentation/providers/tracked_devices.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rubble_core/rubble_core.dart';

part 'target_providers.g.dart';

/// Stores the surface scan.
@Riverpod(keepAlive: true)
CompleteAmbientScan completeAmbientScan(Ref ref) =>
    CompleteAmbientScan(ref.watch(sessionStoreProvider));

/// Excludes a device.
@Riverpod(keepAlive: true)
ExcludeDevice excludeDevice(Ref ref) =>
    ExcludeDevice(ref.watch(sessionStoreProvider));

/// Puts a device back.
@Riverpod(keepAlive: true)
PutBackDevice putBackDevice(Ref ref) =>
    PutBackDevice(ref.watch(sessionStoreProvider));

/// Selects a target.
@Riverpod(keepAlive: true)
SelectTarget selectTarget(Ref ref) {
  final ids = Uuid7Generator(
    nowMs: () => ref.read(clockProvider)().millisecondsSinceEpoch,
    random: Random.secure(),
  );
  return SelectTarget(ref.watch(sessionStoreProvider), () => ids.next().value);
}

/// Track, Exclude and Put back for one search; the state is true while a choice is being stored, so
/// a double tap stores one choice.
@riverpod
class TargetChoice extends _$TargetChoice {
  @override
  bool build(String sessionId) => false;

  /// Follows [key] as a target, shown as [label].
  Future<ChoiceResult> track(String key, String label) => _write(
    () => ref.read(selectTargetProvider).call(SessionId(sessionId), key, label),
  );

  /// Sets [key] aside as a surface phone.
  Future<ChoiceResult> exclude(String key) => _write(
    () => ref.read(excludeDeviceProvider).call(SessionId(sessionId), key),
  );

  /// Puts [key] back among the candidates.
  Future<ChoiceResult> putBack(String key) => _write(
    () => ref.read(putBackDeviceProvider).call(SessionId(sessionId), key),
  );

  Future<ChoiceResult> _write(Future<void> Function() write) async {
    if (state) return ChoiceResult.busy;
    state = true;
    try {
      await write();
      return ChoiceResult.done;
    } on Exception catch (error, stack) {
      AppLogger.error('targets', 'Could not store the choice', error, stack);
      return ChoiceResult.failed;
    } finally {
      if (ref.mounted) state = false;
    }
  }
}

/// The 30 s surface scan of one search. Counts seconds while scanning (the countdown pauses while
/// Bluetooth is off), then stores the surface phones.
@riverpod
class AmbientScanController extends _$AmbientScanController {
  var _seconds = 0;
  var _foreground = true;

  @override
  AmbientState build(String sessionId) {
    // Start counting devices afresh; providers may not change others while they build.
    unawaited(
      Future.microtask(() => ref.read(trackedDevicesProvider.notifier).reset()),
    );
    // Listening (not reading) keeps the tracker running: Riverpod 3 pauses providers nobody listens
    // to, and a paused tracker hears nothing. It also updates the count as phones are heard.
    ref
      ..listen(trackedDevicesProvider, (_, _) => _refresh())
      // Scanning stops in the background (screen off): only foreground seconds count.
      ..listen(appLifecycleProvider, (_, next) {
        _foreground =
            next.value == null || next.value == AppLifecycleState.resumed;
      });
    final timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    ref.onDispose(timer.cancel);
    return _scanning();
  }

  AmbientState _scanning() => switch (ref.read(scanControllerProvider)) {
    ScanRunning() => AmbientScanning(
      remaining: AmbientPolicy.duration - Duration(seconds: _seconds),
      heard: ref.read(trackedDevicesProvider).devices.length,
    ),
    // Not started yet (the scan is being started): show the full countdown.
    ScanIdle() => AmbientScanning(
      remaining: AmbientPolicy.duration - Duration(seconds: _seconds),
      heard: 0,
    ),
    final blocked => AmbientBlocked(blocked),
  };

  void _refresh() {
    if (state is AmbientScanning) state = _scanning();
  }

  void _tick() {
    if (state is! AmbientScanning && state is! AmbientBlocked) return;
    if (_foreground && ref.read(scanControllerProvider) is ScanRunning) {
      _seconds++;
    }
    if (Duration(seconds: _seconds) < AmbientPolicy.duration) {
      state = _scanning();
      return;
    }
    unawaited(_finish());
  }

  Future<void> _finish() async {
    state = const AmbientSaving();
    final surface = surfacePhones(ref.read(trackedDevicesProvider).devices);
    try {
      await ref
          .read(completeAmbientScanProvider)
          .call(SessionId(sessionId), surface, AmbientPolicy.duration);
      if (ref.mounted) state = AmbientDone(surface.length);
    } on Exception catch (error, stack) {
      AppLogger.error(
        'targets',
        'Could not store the surface scan',
        error,
        stack,
      );
      if (ref.mounted) state = const AmbientNotSaved();
    }
  }
}
