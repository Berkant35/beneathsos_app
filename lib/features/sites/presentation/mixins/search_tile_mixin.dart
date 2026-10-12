import 'package:beneathsos_app/core/formatting/date_labels.dart';
import 'package:beneathsos_app/core/sessions/domain/session_store.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';

/// Text of one search in the list.
mixin SearchTileMixin {
  /// "1 point measured · started Oct 12, 14:05", or a note when some data could not be read.
  String tileBody(AppLocalizations l10n, SessionSummary search) {
    final started = dayAndTime(search.createdAt, l10n.localeName);
    return search.readable
        ? l10n.searchTileBody(search.measuredPoints, started)
        : l10n.searchTileUnreadable(started);
  }
}
