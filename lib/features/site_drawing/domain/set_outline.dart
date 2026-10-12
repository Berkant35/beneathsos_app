import 'package:beneathsos_app/core/sessions/domain/session_store.dart';
import 'package:rubble_core/rubble_core.dart';

/// Stores the rubble outline of a search (`RubblePolygonSet`, replacing the previous one).
final class SetOutline {
  /// Creates the use case on [_store].
  const SetOutline(this._store);

  final SessionStore _store;

  /// Stores [outline] for [search].
  Future<void> call(SessionId search, RubblePolygon outline) =>
      _store.append(search, RubblePolygonSet(outline));
}
