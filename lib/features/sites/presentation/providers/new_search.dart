import 'package:beneathsos_app/core/logging/app_logger.dart';
import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/core/settings/presentation/providers/settings_providers.dart';
import 'package:beneathsos_app/features/sites/domain/create_search_result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_search.g.dart';

/// Creates real searches. The state is true while one is being created, so a double tap makes one.
@riverpod
class NewSearch extends _$NewSearch {
  @override
  bool build() => false;

  /// Creates a search named [name].
  Future<CreateSearchResult> create(String name) async {
    if (state) return const CreateAlreadyRunning();
    state = true;
    try {
      return SearchCreated(
        await ref
            .read(sessionStoreProvider)
            .create(
              title: name,
              // The rubble type chosen in Settings.
              engineProfile: ref.read(appSettingsProvider).defaultProfile,
              practice: false,
            ),
      );
    } on Exception catch (error, stack) {
      AppLogger.error('sites', 'Could not create the search', error, stack);
      return const CreateFailed();
    } finally {
      if (ref.mounted) state = false;
    }
  }
}
