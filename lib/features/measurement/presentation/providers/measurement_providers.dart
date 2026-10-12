import 'dart:async';
import 'dart:math';

import 'package:beneathsos_app/core/logging/app_logger.dart';
import 'package:beneathsos_app/core/models/ble_sample.dart';
import 'package:beneathsos_app/core/services/app_lifecycle.dart';
import 'package:beneathsos_app/core/services/ble_service.dart';
import 'package:beneathsos_app/core/services/clock.dart';
import 'package:beneathsos_app/core/services/motion_service.dart';
import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/features/measurement/domain/measurement_rules.dart';
import 'package:beneathsos_app/features/measurement/domain/measurement_state.dart';
import 'package:beneathsos_app/features/measurement/domain/measurement_use_cases.dart';
import 'package:beneathsos_app/features/targets/domain/relink.dart';
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

/// Measuring at points of one search: place, 15 s of still time, store; pauses while moving.
@riverpod
class MeasurementController extends _$MeasurementController {
  /// The point being measured (kept outside [state], which may not be read while disposing).
  PointId? _measuring;

  /// A movement was felt since the last second ticked.
  var _moved = false;
  final _window = <BleSample>[];
  var _targets = <TargetId, String>{};
  var _stillSeconds = 0;
  var _saving = false;
  var _foreground = true;

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
      ..listen(
        bleSamplesProvider,
        (_, next) => _collect(next.value ?? const []),
      )
      // In the background the scan stops: neither time nor readings count.
      ..listen(appLifecycleProvider, (_, next) {
        _foreground =
            next.value == null || next.value == AppLifecycleState.resumed;
      });
    final motion = ref.read(motionPortProvider).accelerations.listen((a) {
      if (isMovement(a)) _moved = true;
    });
    final timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    // Leaving mid-measurement discards the point: never half a measurement (edge case 6).
    final discard = ref.read(discardPointProvider);
    ref.onDispose(() {
      timer.cancel();
      unawaited(motion.cancel());
      final point = _measuring;
      if (point != null && !_saving) {
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
    _targets = {
      for (final MapEntry(:key, :value) in search.targets.entries)
        key: value.peripheralKey,
    };
  }

  void _collect(List<BleSample> batch) {
    // Readings while moving or in the background are left out.
    if (state is! Measuring || !_foreground || _moved) return;
    _window.addAll(batch);
  }

  /// Places a point at [at] and starts measuring.
  Future<void> place(SitePoint at) async {
    if (state is! ChoosingPoint) return;
    try {
      final point = await ref
          .read(placePointProvider)
          .call(SessionId(sessionId), at);
      if (!ref.mounted) return;
      _window.clear();
      _stillSeconds = 0;
      _moved = false;
      _measuring = point;
      state = _measuringState(point, at, moving: false);
    } on Exception catch (error, stack) {
      AppLogger.error('measurement', 'Could not place the point', error, stack);
      if (ref.mounted) state = const ChoosingPoint(last: PointNotSaved());
    }
  }

  /// Throws the point being measured away.
  Future<void> discard() async {
    final current = state;
    if (current is! Measuring) return;
    _measuring = null;
    state = const ChoosingPoint();
    try {
      await ref
          .read(discardPointProvider)
          .call(
            SessionId(sessionId),
            current.point,
            DiscardReason.userDiscarded,
          );
    } on Exception catch (error, stack) {
      AppLogger.error(
        'measurement',
        'Could not discard the point',
        error,
        stack,
      );
    }
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
      AppLogger.error(
        'measurement',
        'Could not relink the target',
        error,
        stack,
      );
    }
  }

  Measuring _measuringState(
    PointId point,
    SitePoint at, {
    required bool moving,
  }) => Measuring(
    point: point,
    at: at,
    remaining: MeasurementPolicy.duration - Duration(seconds: _stillSeconds),
    moving: moving,
    heard: {
      for (final MapEntry(:key, :value) in _targets.entries)
        key: _window.where((s) => s.key == value).length,
    },
    relink: _suggestion(),
  );

  RelinkSuggestion? _suggestion() {
    final events = ref.read(trackedDevicesProvider).events;
    for (final MapEntry(:key, :value) in _targets.entries) {
      final found = suggestRelinks(targetKey: value, events: events);
      if (found.isNotEmpty) {
        return (
          target: key,
          from: value,
          to: found.first.key,
          gapSeconds: found.first.gapSeconds,
        );
      }
    }
    return null;
  }

  void _tick() {
    final current = state;
    if (current is! Measuring || _saving) return;
    // A second counts only when the phone did not move during it.
    final moved = _moved;
    _moved = false;
    if (_foreground && !moved) _stillSeconds++;
    if (Duration(seconds: _stillSeconds) < MeasurementPolicy.duration) {
      state = _measuringState(current.point, current.at, moving: moved);
      return;
    }
    unawaited(_finish(current));
  }

  Future<void> _finish(Measuring current) async {
    _saving = true;
    _measuring = null;
    final readings = summarizeReadings(_targets, _window);
    try {
      await ref
          .read(completeMeasurementProvider)
          .call(
            SessionId(sessionId),
            current.point,
            duration: MeasurementPolicy.duration,
            readings: readings,
            samples: List.of(_window),
          );
      if (ref.mounted) state = ChoosingPoint(last: PointSaved(readings));
    } on Exception catch (error, stack) {
      AppLogger.error(
        'measurement',
        'Could not store the measurement',
        error,
        stack,
      );
      if (ref.mounted) state = const ChoosingPoint(last: PointNotSaved());
    } finally {
      _saving = false;
    }
  }
}
