import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/logging/app_logger.dart';
import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/core/settings/domain/app_settings.dart';
import 'package:beneathsos_app/features/settings/presentation/widgets/confirm_delete_dialog.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Words and actions of the Settings screen.
mixin SettingsMixin {
  /// "Phone's language", "Türkçe", "English".
  String languageLabel(AppLocalizations l10n, AppLanguage language) =>
      switch (language) {
        AppLanguage.system => l10n.languageSystem,
        AppLanguage.turkish => l10n.languageTurkish,
        AppLanguage.english => l10n.languageEnglish,
      };

  /// "Voided (pancake)" or "Dense".
  String rubbleTypeLabel(AppLocalizations l10n, String profile) =>
      profile == 'dense@1' ? l10n.rubbleDense : l10n.rubbleVoided;

  /// Asks, then deletes the practice searches or all of them; says how it went.
  Future<void> deleteSearches(
    BuildContext context,
    WidgetRef ref, {
    required bool practiceOnly,
  }) async {
    final l10n = context.l10n;
    final yes = await ConfirmDeleteDialog.confirm(
      context,
      title: practiceOnly
          ? l10n.settingsDeletePracticeTitle
          : l10n.settingsDeleteAllTitle,
      body: practiceOnly
          ? l10n.settingsDeletePracticeBody
          : l10n.settingsDeleteAllBody,
    );
    if (!yes) return;
    String message;
    try {
      await ref.read(deleteSearchProvider).all(practiceOnly: practiceOnly);
      message = l10n.settingsDeleted;
    } on Object catch (error, stack) {
      AppLogger.error('settings', 'Could not delete searches', error, stack);
      message = l10n.sitesDeleteFailed;
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
