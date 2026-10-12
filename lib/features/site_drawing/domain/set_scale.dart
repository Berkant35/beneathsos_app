import 'package:beneathsos_app/core/sessions/domain/session_store.dart';
import 'package:rubble_core/rubble_core.dart';

/// Stores how drawn lengths relate to real ones (`ScaleSet`) and how the rescuer knows.
final class SetScale {
  /// Creates the use case on [_store].
  const SetScale(this._store);

  final SessionStore _store;

  /// Stores [factor] (real / drawn) measured by [source] for [search].
  Future<void> call(SessionId search, double factor, ScaleSource source) =>
      _store.append(search, ScaleSet(factor: factor, source: source));
}
