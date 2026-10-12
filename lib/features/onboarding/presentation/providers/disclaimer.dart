import 'package:beneathsos_app/core/logging/app_logger.dart';
import 'package:beneathsos_app/core/settings/presentation/providers/settings_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'disclaimer.g.dart';

/// Whether the current disclaimer was accepted (product rule 5). It gates the rescuer flow, never
/// victim mode. Bump [version] when the disclaimer text changes: everyone sees it again.
@Riverpod(keepAlive: true)
class Disclaimer extends _$Disclaimer {
  /// Version of the accepted text.
  static const version = '1';
  static const _key = 'disclaimer_accepted';

  @override
  Future<bool> build() async =>
      await ref.watch(settingsStoreProvider).watch(_key).first == version;

  /// Records the acceptance. If it cannot be stored, it still counts for this run (logged), so the
  /// rescuer is never blocked.
  Future<void> accept() async {
    try {
      await ref.read(settingsStoreProvider).write(_key, version);
    } on Exception catch (error, stack) {
      AppLogger.error(
        'onboarding',
        'Could not store the acceptance',
        error,
        stack,
      );
    }
    state = const AsyncData(true);
  }
}
