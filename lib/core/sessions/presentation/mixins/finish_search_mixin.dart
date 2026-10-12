import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/logging/app_logger.dart';
import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/core/sessions/presentation/widgets/finish_search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rubble_core/rubble_core.dart';

/// "Finish this search": ask, finish, and say so when it could not be stored.
mixin FinishSearchMixin {
  /// Asks, then finishes [search] (its events stay stored). A failure is logged and shown.
  Future<void> confirmAndFinish(
    BuildContext context,
    WidgetRef ref,
    SessionId search,
  ) async {
    if (!await FinishSearchDialog.confirm(context)) return;
    try {
      await ref.read(finishSearchProvider).call(search);
    } on Exception catch (error, stack) {
      AppLogger.error('sessions', 'Could not finish the search', error, stack);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.finishFailed)));
      }
    }
  }
}
