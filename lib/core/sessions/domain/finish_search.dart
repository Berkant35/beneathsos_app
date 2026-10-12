import 'package:beneathsos_app/core/sessions/domain/session_store.dart';
import 'package:rubble_core/rubble_core.dart';

/// Finishes a search: appends `SessionClosed`. Its events stay stored; it cannot be continued.
final class FinishSearch {
  /// Creates the use case on [_store].
  const FinishSearch(this._store);

  final SessionStore _store;

  /// Finishes [search].
  Future<void> call(SessionId search) =>
      _store.append(search, const SessionClosed());
}
