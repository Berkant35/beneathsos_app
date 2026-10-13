import 'package:beneathsos_app/features/export/presentation/providers/export_providers.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/widgets.dart';

/// Words of the export screen.
mixin ExportMixin {
  /// The disclaimer as written into every export file — in English, for researchers anywhere.
  String fileDisclaimer() {
    final en = lookupAppLocalizations(const Locale('en'));
    return [
      '${en.noticeDoesTitle}: ${en.noticeDoesBody}',
      '${en.noticeDoesNotTitle}: ${en.noticeDoesNotBody}',
      en.homeIndependence,
    ].join('\n');
  }

  /// How the outcome line looks.
  StatusKind outcomeKind(ExportState state) =>
      state is ExportFailed ? StatusKind.attention : StatusKind.ready;

  /// The outcome line, or null before exporting.
  String? outcome(AppLocalizations l10n, ExportState state) => switch (state) {
    ExportReady() || Exporting() => null,
    Exported() => l10n.exportDone,
    ExportFailed() => l10n.exportFailed,
  };
}
