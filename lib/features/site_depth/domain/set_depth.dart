import 'package:beneathsos_app/core/sessions/domain/session_store.dart';
import 'package:rubble_core/rubble_core.dart';

/// Stores how high the rubble stands and where the person most likely was (`RubbleDepthSet`).
final class SetDepth {
  /// Creates the use case on [_store].
  const SetDepth(this._store);

  final SessionStore _store;

  /// Stores [height] and [level] for [search].
  Future<void> call(SessionId search, Meters height, TrappedLevel level) =>
      _store.append(search, RubbleDepthSet(height: height, level: level));
}
