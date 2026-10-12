import 'dart:async';

import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/core/sessions/domain/session_store.dart';
import 'package:beneathsos_app/features/preview/presentation/providers/practice_session.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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

  /// Opens [search]: a real one in its overview, a practice one on the preview map (later steps are
  /// recorded into it — the preview never resumes a real search).
  void continueSearch(
    BuildContext context,
    WidgetRef ref,
    SessionSummary search,
  ) {
    if (!search.practice) {
      SiteRoute(sessionId: search.id.value).go(context);
      return;
    }
    unawaited(ref.read(practiceSessionProvider.notifier).resume(search));
    const PreviewMapRoute().go(context);
  }
}
