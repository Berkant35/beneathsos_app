import 'package:rubble_core/rubble_core.dart';

/// What happened to "Create search".
sealed class CreateSearchResult {
  const CreateSearchResult();
}

/// The search exists now.
final class SearchCreated extends CreateSearchResult {
  /// Creates the result.
  const SearchCreated(this.id);

  /// The new search.
  final SessionId id;
}

/// Another tap is already creating one; nothing to do.
final class CreateAlreadyRunning extends CreateSearchResult {
  /// Creates the result.
  const CreateAlreadyRunning();
}

/// The search could not be stored; the user is told and can try again.
final class CreateFailed extends CreateSearchResult {
  /// Creates the result.
  const CreateFailed();
}
