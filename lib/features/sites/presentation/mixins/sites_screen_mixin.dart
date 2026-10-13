import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/logging/app_logger.dart';
import 'package:beneathsos_app/core/sessions/domain/session_store.dart';
import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/features/sites/presentation/widgets/delete_search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Actions of the searches list.
mixin SitesScreenMixin {
  /// Asks, then deletes [search]; says so when it could not be deleted.
  Future<void> deleteSearch(
    BuildContext context,
    WidgetRef ref,
    SessionSummary search,
  ) async {
    if (!await DeleteSearchDialog.confirm(context, search.title)) return;
    try {
      await ref.read(deleteSearchProvider)(search.id);
    } on Object catch (error, stack) {
      AppLogger.error('sites', 'Could not delete a search', error, stack);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.sitesDeleteFailed)));
      }
    }
  }
}
