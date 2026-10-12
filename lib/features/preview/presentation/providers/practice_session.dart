import 'dart:math';

import 'package:beneathsos_app/core/logging/app_logger.dart';
import 'package:beneathsos_app/core/services/clock.dart';
import 'package:beneathsos_app/core/sessions/domain/session_store.dart';
import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/features/preview/domain/practice_sample.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rubble_core/rubble_core.dart';

part 'practice_session.g.dart';

/// Records the preview journey as a practice search; the state is its session id (null before
/// "Start"). Steps run one after the other in call order, so screens need not wait for them; a
/// failed write is logged and never blocks the preview.
@Riverpod(keepAlive: true)
class PracticeSession extends _$PracticeSession {
  late final Uuid7Generator _ids = Uuid7Generator(
    nowMs: () => ref.read(clockProvider)().millisecondsSinceEpoch,
    random: Random.secure(),
  );
  int _points = 0;
  Future<void> _last = Future.value();

  @override
  SessionId? build() => null;

  /// Starts a new practice search named [title].
  Future<void> start(String title) => _guard(() async {
    _points = 0;
    state = null; // if creating fails, later steps must not go into the previous search
    state = await ref
        .read(sessionStoreProvider)
        .create(
          title: title,
          engineProfile: PracticeSample.engineProfile,
          practice: true,
        );
  });

  /// Continues an earlier practice [search] (from the home screen), after any step still running.
  /// A real search is refused: the preview's sample data must never go into it.
  Future<void> resume(SessionSummary search) => _guard(() async {
    if (!search.practice) {
      AppLogger.error('practice', 'Refused to resume a real search');
      return;
    }
    _points = search.measuredPoints;
    state = search.id;
  });

  /// The outline is done.
  Future<void> outlineDrawn() =>
      _record([RubblePolygonSet(PracticeSample.outline)]);

  /// The ambient scan found the surface phones.
  Future<void> ambientScanned() => _record([
    const AmbientScanCompleted(
      blacklisted: PracticeSample.surfacePhones,
      duration: PracticeSample.ambientScan,
    ),
  ]);

  /// The target was chosen.
  Future<void> targetChosen() => _record([
    const TargetSelected(
      target: PracticeSample.target,
      peripheralKey: PracticeSample.targetKey,
      label: PracticeSample.targetLabel,
    ),
  ]);

  /// A point was measured.
  Future<void> pointMeasured() {
    final point = _nextPoint();
    return _record([
      point.placed,
      MeasurementCompleted(
        point: point.id,
        duration: PracticeSample.measurement,
        readings: [PracticeSample.reading],
      ),
    ]);
  }

  /// The point being measured was thrown away.
  Future<void> pointDiscarded() {
    final point = _nextPoint();
    return _record([
      point.placed,
      MeasurementDiscarded(
        point: point.id,
        reason: DiscardReason.userDiscarded,
      ),
    ]);
  }

  ({PointId id, MeasurementPointPlaced placed}) _nextPoint() {
    final id = PointId(_ids.next().value);
    final at = PracticeSample.pointAt(_points++);
    return (id: id, placed: MeasurementPointPlaced(point: id, at: at));
  }

  Future<void> _record(List<SessionEvent> events) => _guard(() async {
    final session = state;
    if (session == null) return;
    final store = ref.read(sessionStoreProvider);
    for (final event in events) {
      await store.append(session, event);
    }
  });

  Future<void> _guard(Future<void> Function() write) {
    final step = _last.then((_) => _run(write));
    // The next step waits for this one but never inherits its error (an Error is a bug: it reaches
    // the caller of this step only).
    _last = step.then<void>((_) {}, onError: (Object _) {});
    return step;
  }

  Future<void> _run(Future<void> Function() write) async {
    try {
      await write();
    } on Exception catch (error, stack) {
      AppLogger.error(
        'practice',
        'Could not record a preview step',
        error,
        stack,
      );
    }
  }
}
