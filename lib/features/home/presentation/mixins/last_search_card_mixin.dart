import 'package:beneathsos_app/core/logging/app_logger.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/core/sessions/domain/session_store.dart';
import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/features/preview/presentation/providers/practice_session.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rubble_core/rubble_core.dart';

/// Text and actions of the "last search" card.
mixin LastSearchCardMixin {
  /// "Last search", or "Last practice search" for a practice one.
  String cardTitle(AppLocalizations l10n, SessionSummary search) =>
      search.practice ? l10n.lastPracticeTitle : l10n.lastSearchTitle;

  /// "<title> · N points measured · started HH:mm".
  String cardBody(AppLocalizations l10n, SessionSummary search) =>
      l10n.lastSearchBody(
        search.title,
        search.measuredPoints,
        DateFormat.Hm(l10n.localeName).format(search.createdAt),
      );

  /// Opens the map of [search]; later steps are recorded into it.
  void continueSearch(
    BuildContext context,
    WidgetRef ref,
    SessionSummary search,
  ) {
    ref.read(practiceSessionProvider.notifier).resume(search.id);
    const PreviewMapRoute().go(context);
  }

  /// Closes [search] (its events stay stored); a failure is logged.
  Future<void> finishSearch(WidgetRef ref, SessionSummary search) async {
    try {
      await ref
          .read(sessionStoreProvider)
          .append(search.id, const SessionClosed());
    } on Exception catch (error, stack) {
      AppLogger.error('home', 'Could not finish the search', error, stack);
    }
  }
}
