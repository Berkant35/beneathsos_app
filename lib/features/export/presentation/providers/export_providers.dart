import 'dart:math';

import 'package:beneathsos_app/core/logging/app_logger.dart';
import 'package:beneathsos_app/core/services/clock.dart';
import 'package:beneathsos_app/core/services/share_service.dart';
import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/features/export/domain/export_search.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rubble_core/rubble_core.dart';

part 'export_providers.g.dart';

/// How an export went.
sealed class ExportState {
  const ExportState();
}

/// Not exported yet.
final class ExportReady extends ExportState {
  /// Creates the state.
  const ExportReady();
}

/// Building the files and showing the share sheet.
final class Exporting extends ExportState {
  /// Creates the state.
  const Exporting();
}

/// The share sheet closed.
final class Exported extends ExportState {
  /// Creates the state.
  const Exported();
}

/// The files could not be built or shared.
final class ExportFailed extends ExportState {
  /// Creates the state.
  const ExportFailed();
}

/// The export use case; a fresh 16-byte salt per export.
@riverpod
ExportSearch exportSearch(Ref ref) {
  final random = Random.secure();
  return ExportSearch(
    ref.watch(sessionStoreProvider),
    ref.watch(shareProvider),
    now: ref.watch(clockProvider),
    salt: () => [for (var i = 0; i < 16; i++) random.nextInt(256)],
  );
}

/// Exports one search.
@riverpod
class ExportController extends _$ExportController {
  @override
  ExportState build(String sessionId) => const ExportReady();

  /// Exports with [disclaimer] in the file; a second tap while exporting does nothing.
  Future<void> export({
    required String disclaimer,
    required String subject,
  }) async {
    if (state is Exporting) return;
    state = const Exporting();
    try {
      await ref.read(exportSearchProvider)(
        SessionId(sessionId),
        disclaimer: disclaimer,
        subject: subject,
      );
      if (ref.mounted) state = const Exported();
    } on Object catch (error, stack) {
      AppLogger.error('export', 'Export failed', error, stack);
      if (ref.mounted) state = const ExportFailed();
    }
  }
}
