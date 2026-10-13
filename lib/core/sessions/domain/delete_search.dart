import 'package:beneathsos_app/core/sessions/domain/session_store.dart';
import 'package:rubble_core/rubble_core.dart';

/// Deletes a search from this phone with everything recorded in it — only when the person asks.
final class DeleteSearch {
  /// Creates the use case on [_store].
  const DeleteSearch(this._store);

  final SessionStore _store;

  /// Deletes [search].
  Future<void> call(SessionId search) => _store.delete(search);

  /// Deletes every search, or with [practiceOnly] only the practice ones.
  Future<void> all({bool practiceOnly = false}) =>
      _store.deleteAll(practiceOnly: practiceOnly);
}
