import 'dart:developer' as developer;

/// Thin logger; replaces `print` everywhere.
abstract final class AppLogger {
  /// Logs a debug message under [tag].
  static void debug(String tag, String message) =>
      developer.log(message, name: tag);

  /// Logs an error with optional [error] and [stackTrace].
  static void error(
    String tag,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) => developer.log(
    message,
    name: tag,
    level: 1000,
    error: error,
    stackTrace: stackTrace,
  );
}
