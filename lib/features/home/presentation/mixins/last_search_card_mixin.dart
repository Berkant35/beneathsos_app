import 'dart:async';

import 'package:beneathsos_app/core/logging/app_logger.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/core/sessions/domain/session_store.dart';
import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/features/home/presentation/widgets/finish_search_dialog.dart';
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

  /// "<title> · N points measured · started HH:mm", or a note when some data could not be read.
  String cardBody(AppLocalizations l10n, SessionSummary search) {
    final time = DateFormat.Hm(l10n.localeName).format(search.createdAt);
    return search.readable
        ? l10n.lastSearchBody(search.title, search.measuredPoints, time)
        : l10n.lastSearchUnreadable(search.title, time);
  }

  /// Only practice searches continue in the preview; real searches get their own flow (phase 4+).
  bool canContinue(SessionSummary search) => search.practice;

  /// Opens the map of [search]; later steps are recorded into it.
  void continueSearch(
    BuildContext context,
    WidgetRef ref,
    SessionSummary search,
  ) {
    unawaited(ref.read(practiceSessionProvider.notifier).resume(search));
    const PreviewMapRoute().go(context);
  }

  /// After the user confirms, closes [search] (its events stay stored); a failure is logged.
  Future<void> finishSearch(
    BuildContext context,
    WidgetRef ref,
    SessionSummary search,
  ) async {
    if (!await FinishSearchDialog.confirm(context)) return;
    try {
      await ref
          .read(sessionStoreProvider)
          .append(search.id, const SessionClosed());
    } on Exception catch (error, stack) {
      AppLogger.error('home', 'Could not finish the search', error, stack);
    }
  }
}
