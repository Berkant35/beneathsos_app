/// What happened to Track, Exclude or Put back.
enum ChoiceResult {
  /// Stored.
  done,

  /// Another choice is still being stored; nothing was done (double tap).
  busy,

  /// Could not be stored; the rescuer is told.
  failed,
}
