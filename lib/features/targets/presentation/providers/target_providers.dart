import 'dart:async';
import 'dart:math';

import 'package:beneathsos_app/core/logging/app_logger.dart';
import 'package:beneathsos_app/core/scanning/presentation/providers/scan_controller.dart';
import 'package:beneathsos_app/core/scanning/presentation/providers/scan_state.dart';
import 'package:beneathsos_app/core/services/clock.dart';
import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/features/targets/domain/ambient_state.dart';
import 'package:beneathsos_app/features/targets/domain/candidates.dart';
import 'package:beneathsos_app/features/targets/domain/target_use_cases.dart';
import 'package:beneathsos_app/features/targets/presentation/providers/tracked_devices.dart';
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

/// Selects a target.
@Riverpod(keepAlive: true)
SelectTarget selectTarget(Ref ref) {
  final ids = Uuid7Generator(
    nowMs: () => ref.read(clockProvider)().millisecondsSinceEpoch,
    random: Random.secure(),
  );
  return SelectTarget(ref.watch(sessionStoreProvider), () => ids.next().value);
}

/// Scans while a screen that needs it is open (surface scan, candidates); shared, so moving from one
/// to the other never stops the scan in between.
@riverpod
Future<void> scanWhileOpen(Ref ref) async {
  final scanner = ref.read(scanControllerProvider.notifier);
  // Stopping touches other providers, which a dispose callback may not do: stop right after it.
  ref.onDispose(() => unawaited(Future.microtask(scanner.stop)));
  await scanner.start();
}

/// The 30 s surface scan of one search. Counts seconds while scanning (the countdown pauses while
/// Bluetooth is off), then stores the surface phones.
@riverpod
class AmbientScanController extends _$AmbientScanController {
  var _seconds = 0;

  @override
  AmbientState build(String sessionId) {
    // Start counting devices afresh; providers may not change others while they build.
    unawaited(
      Future.microtask(() => ref.read(trackedDevicesProvider.notifier).reset()),
    );
    // Listening (not reading) keeps the tracker running: Riverpod 3 pauses providers nobody listens
    // to, and a paused tracker hears nothing. It also updates the count as phones are heard.
    ref.listen(trackedDevicesProvider, (_, _) => _refresh());
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
    if (ref.read(scanControllerProvider) is ScanRunning) _seconds++;
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
