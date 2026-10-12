/// What happened to "Outline done".
sealed class SaveOutlineResult {
  const SaveOutlineResult();
}

/// The outline is stored (or was already stored unchanged).
final class OutlineSaved extends SaveOutlineResult {
  /// Creates the result.
  const OutlineSaved();
}

/// The outline is not a valid rubble outline yet; nothing was stored.
final class OutlineNotValid extends SaveOutlineResult {
  /// Creates the result.
  const OutlineNotValid();
}

/// Another tap is already saving; nothing to do.
final class OutlineSaveRunning extends SaveOutlineResult {
  /// Creates the result.
  const OutlineSaveRunning();
}

/// The outline could not be stored; the user is told and can try again.
final class OutlineNotSaved extends SaveOutlineResult {
  /// Creates the result.
  const OutlineNotSaved();
}
