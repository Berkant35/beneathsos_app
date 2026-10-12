import 'package:beneathsos_app/core/models/ble_sample.dart';
import 'package:beneathsos_app/core/sessions/domain/session_store.dart';
import 'package:rubble_core/rubble_core.dart';

/// Places a measurement point where the rescuer stands.
final class PlacePoint {
  /// Creates the use case on [_store]; [_newId] makes point ids.
  const PlacePoint(this._store, this._newId);

  final SessionStore _store;
  final String Function() _newId;

  /// Places a point at [at] in [search] and returns its id.
  Future<PointId> call(SessionId search, SitePoint at) async {
    final point = PointId(_newId());
    await _store.append(search, MeasurementPointPlaced(point: point, at: at));
    return point;
  }
}

/// Stores a finished measurement and its raw readings.
final class CompleteMeasurement {
  /// Creates the use case on [_store].
  const CompleteMeasurement(this._store);

  final SessionStore _store;

  /// Stores [readings] (one per target, "not heard" included — rule 3) and the raw [samples].
  Future<void> call(
    SessionId search,
    PointId point, {
    required Duration duration,
    required List<TargetReading> readings,
    required List<BleSample> samples,
  }) async {
    await _store.addSamples(search, point, samples);
    await _store.append(
      search,
      MeasurementCompleted(
        point: point,
        duration: duration,
        readings: readings,
      ),
    );
  }
}

/// Throws a point away, with the reason (its earlier readings stay in the log).
final class DiscardPoint {
  /// Creates the use case on [_store].
  const DiscardPoint(this._store);

  final SessionStore _store;

  /// Discards [point] of [search] because of [reason].
  Future<void> call(SessionId search, PointId point, DiscardReason reason) =>
      _store.append(search, MeasurementDiscarded(point: point, reason: reason));
}

/// The rescuer confirms that a new Bluetooth identity is the same phone (identity rotation).
final class RelinkTarget {
  /// Creates the use case on [_store].
  const RelinkTarget(this._store);

  final SessionStore _store;

  /// [target] of [search] is now heard as [to] (was [from]).
  Future<void> call(
    SessionId search,
    TargetId target,
    String from,
    String to,
  ) =>
      _store.append(search, TargetRelinked(target: target, from: from, to: to));
}
