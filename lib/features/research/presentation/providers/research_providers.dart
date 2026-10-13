import 'package:beneathsos_app/core/logging/app_logger.dart';
import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/features/research/domain/record_found.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rubble_core/rubble_core.dart';

part 'research_providers.g.dart';

/// The record-where-it-was-found use case.
@riverpod
RecordFound recordFound(Ref ref) =>
    RecordFound(ref.watch(sessionStoreProvider));

/// Where recording the found spot stands.
sealed class FoundStep {
  const FoundStep();
}

/// Not recording.
final class FoundIdle extends FoundStep {
  /// Creates the step.
  const FoundIdle();
}

/// Waiting for the tap on the map.
final class FoundChoosing extends FoundStep {
  /// Creates the step.
  const FoundChoosing();
}

/// Saving the confirmed spot.
final class FoundSaving extends FoundStep {
  /// Creates the step.
  const FoundSaving();
}

/// The last record could not be saved.
final class FoundFailed extends FoundStep {
  /// Creates the step.
  const FoundFailed();
}

/// Records where a phone was found: choose (tap the map), confirm, save — once per confirmation.
@riverpod
class RecordFoundController extends _$RecordFoundController {
  @override
  FoundStep build(String sessionId) => const FoundIdle();

  /// Waits for the tap on the map.
  void start() => state = const FoundChoosing();

  /// Stops waiting.
  void cancel() => state = const FoundIdle();

  /// Saves [target] found at [at] (drawn lengths); ignored unless choosing (a double tap saves once).
  Future<void> record(TargetId target, SitePoint at) async {
    if (state is! FoundChoosing) return;
    state = const FoundSaving();
    try {
      await ref.read(recordFoundProvider)(SessionId(sessionId), target, at);
      if (ref.mounted) state = const FoundIdle();
    } on Object catch (error, stack) {
      AppLogger.error(
        'research',
        'Could not record the found spot',
        error,
        stack,
      );
      if (ref.mounted) state = const FoundFailed();
    }
  }
}
