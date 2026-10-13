import 'dart:async';
import 'dart:math';

import 'package:beneathsos_app/core/logging/app_logger.dart';
import 'package:beneathsos_app/core/scanning/presentation/providers/scan_controller.dart';
import 'package:beneathsos_app/core/scanning/presentation/providers/scan_state.dart';
import 'package:beneathsos_app/core/services/app_lifecycle.dart';
import 'package:beneathsos_app/core/services/ble_service.dart';
import 'package:beneathsos_app/core/services/clock.dart';
import 'package:beneathsos_app/core/services/motion_service.dart';
import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/core/settings/presentation/providers/settings_providers.dart';
import 'package:beneathsos_app/features/measurement/domain/measurement_rules.dart';
import 'package:beneathsos_app/features/measurement/domain/measurement_state.dart';
import 'package:beneathsos_app/features/measurement/domain/measurement_use_cases.dart';
import 'package:beneathsos_app/features/targets/presentation/providers/tracked_devices.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rubble_core/rubble_core.dart';

part 'measurement_providers.g.dart';

/// Places points.
@Riverpod(keepAlive: true)
PlacePoint placePoint(Ref ref) {
  final ids = Uuid7Generator(
    nowMs: () => ref.read(clockProvider)().millisecondsSinceEpoch,
    random: Random.secure(),
  );
  return PlacePoint(ref.watch(sessionStoreProvider), () => ids.next().value);
}

/// Stores measurements.
@Riverpod(keepAlive: true)
CompleteMeasurement completeMeasurement(Ref ref) =>
    CompleteMeasurement(ref.watch(sessionStoreProvider));

/// Discards points.
@Riverpod(keepAlive: true)
DiscardPoint discardPoint(Ref ref) =>
    DiscardPoint(ref.watch(sessionStoreProvider));

/// Relinks targets.
@Riverpod(keepAlive: true)
RelinkTarget relinkTarget(Ref ref) =>
    RelinkTarget(ref.watch(sessionStoreProvider));

/// Measuring at points of one search: choose a spot, start, 15 s of still time while scanning, store.
@riverpod
class MeasurementController extends _$MeasurementController {
  var _window = MeasurementWindow();
  var _targets = <TargetId, String>{};
  final _rejected = <(String, String)>{};
  var _foreground = true;
  var _busy = false;
  var _cleaned = false;

  /// The point being measured (kept outside [state], which may not be read while disposing).
  PointId? _measuring;

  @override
  MeasurementState build(String sessionId) {
    final session = SessionId(sessionId);
    ref
      ..listen(
        sessionStateProvider(sessionId),
        (_, next) => _readTargets(next.value),
        fireImmediately: true,
      )
      // Listening keeps the tracker (and its relink log) running.
      ..listen(trackedDevicesProvider, (_, _) {})
      ..listen(bleSamplesProvider, (_, next) {
        if (state is Measuring) _window.heard(next.value ?? const []);
      })
      ..listen(appLifecycleProvider, (_, next) {
        _foreground =
            next.value == null || next.value == AppLifecycleState.resumed;
      });
    final motion = ref
        .read(motionPortProvider)
        .accelerations
        .listen((a) => _window.felt(a));
    final timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    final discard = ref.read(discardPointProvider);
    ref.onDispose(() {
      timer.cancel();
      unawaited(motion.cancel());
      // Leaving mid-measurement discards the point: never half a measurement (edge case 6).
      final point = _measuring;
      if (point != null) {
        unawaited(
          Future.microtask(
            () => discard(session, point, DiscardReason.interrupted),
          ),
        );
      }
    });
    return const ChoosingPoint();
  }

  void _readTargets(SessionState? search) {
    if (search == null) return;
    if (!_cleaned) {
      _cleaned = true;
      // A point placed but never finished (the app was killed while measuring): never half a
      // measurement (edge case 6).
      for (final point in search.points.values) {
        if (point.status == PointStatus.placed && point.readings.isEmpty) {
          unawaited(
            Future.microtask(
              () => _discard(point.id, DiscardReason.interrupted),
            ),
          );
        }
      }
    }
    _targets = {
      for (final MapEntry(:key, :value) in search.targets.entries)
        key: value.peripheralKey,
    };
  }

  /// The rescuer tapped where they stand (it can be moved by tapping again).
  void choose(SitePoint at) {
    if (state case ChoosingPoint(:final last)) {
      state = ChoosingPoint(last: last, pending: at);
    }
  }

  /// Places the chosen point and starts measuring (once, however often it is tapped).
  Future<void> start() async {
    final at = switch (state) {
      ChoosingPoint(:final pending?) => pending,
      _ => null,
    };
    if (at == null || _busy) return;
    _busy = true;
    try {
      final point = await ref
          .read(placePointProvider)
          .call(SessionId(sessionId), at);
      if (!ref.mounted) return;
      _window = MeasurementWindow(
        duration: ref.read(appSettingsProvider).measureDuration,
      );
      _measuring = point;
      state = _measuringState(point, at, moving: false);
    } on Exception catch (error, stack) {
      AppLogger.error('measurement', 'Could not place the point', error, stack);
      if (ref.mounted) state = const ChoosingPoint(last: PointNotSaved());
    } finally {
      _busy = false;
    }
  }

  /// Throws the point being measured away (not once it is being stored).
  Future<void> discard() async {
    final current = state;
    if (current is! Measuring) return;
    _measuring = null;
    state = const ChoosingPoint();
    await _discard(current.point, DiscardReason.userDiscarded);
  }

  /// The rescuer confirms [suggestion]: readings of the new identity count from now on.
  Future<void> relink(RelinkSuggestion suggestion) async {
    try {
      await ref
          .read(relinkTargetProvider)
          .call(
            SessionId(sessionId),
            suggestion.target,
            suggestion.from,
            suggestion.to,
          );
      _targets = {..._targets, suggestion.target: suggestion.to};
    } on Exception catch (error, stack) {
      AppLogger.error('measurement', 'Could not relink', error, stack);
    }
  }

  /// The rescuer says the new identity is not the target: never offered again.
  void rejectRelink(RelinkSuggestion suggestion) {
    _rejected.add((suggestion.from, suggestion.to));
    if (state case final Measuring m) {
      state = _measuringState(m.point, m.at, moving: m.moving);
    }
  }

  Measuring _measuringState(
    PointId point,
    SitePoint at, {
    required bool moving,
  }) => Measuring(
    point: point,
    at: at,
    remaining: _window.remaining,
    moving: moving,
    heard: {
      for (final MapEntry(:key, :value) in _targets.entries)
        key: _window.count(value),
    },
    relink: relinkSuggestion(
      _targets,
      ref.read(trackedDevicesProvider),
      nowMillis: ref.read(clockProvider)().millisecondsSinceEpoch,
      rejected: _rejected,
    ),
  );

  void _tick() {
    final current = state;
    if (current is! Measuring) return;
    final moved = _window.tick(
      // Without a running scan no second counts: never a false "not heard" (rule 3).
      scanning: ref.read(scanControllerProvider) is ScanRunning,
      foreground: _foreground,
    );
    if (!_window.complete) {
      state = _measuringState(current.point, current.at, moving: moved);
      return;
    }
    unawaited(_finish(current));
  }

  Future<void> _finish(Measuring current) async {
    state = SavingMeasurement(at: current.at);
    _measuring = null;
    final kept = _window.kept;
    if (kept.isEmpty) {
      // Not even a bystander's phone was heard: the radio did not work. Not a "not heard".
      await _discard(current.point, DiscardReason.interrupted);
      if (ref.mounted) state = const ChoosingPoint(last: PointRadioSilent());
      return;
    }
    final readings = summarizeReadings(_targets, kept);
    try {
      await ref
          .read(completeMeasurementProvider)
          .call(
            SessionId(sessionId),
            current.point,
            duration: _window.duration,
            readings: readings,
            samples: kept,
          );
      if (ref.mounted) state = ChoosingPoint(last: PointSaved(readings));
    } on Exception catch (error, stack) {
      AppLogger.error('measurement', 'Could not store the point', error, stack);
      await _discard(current.point, DiscardReason.interrupted);
      if (ref.mounted) state = const ChoosingPoint(last: PointNotSaved());
    }
  }

  Future<void> _discard(PointId point, DiscardReason reason) async {
    try {
      await ref
          .read(discardPointProvider)
          .call(SessionId(sessionId), point, reason);
    } on Exception catch (error, stack) {
      AppLogger.error(
        'measurement',
        'Could not discard the point',
        error,
        stack,
      );
    }
  }
}
