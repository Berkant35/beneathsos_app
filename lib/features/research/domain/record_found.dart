import 'package:beneathsos_app/core/sessions/domain/session_store.dart';
import 'package:rubble_core/rubble_core.dart';

/// Records where a target's phone was actually found (`GroundTruthRecorded`, append-only: recording
/// again replaces it in the projection, the history stays).
final class RecordFound {
  /// Creates the use case on [_store].
  const RecordFound(this._store);

  final SessionStore _store;

  /// Records [target] of [search] found at [at] (drawn lengths, like every site point).
  Future<void> call(SessionId search, TargetId target, SitePoint at) =>
      _store.append(search, GroundTruthRecorded(target: target, at: at));
}
