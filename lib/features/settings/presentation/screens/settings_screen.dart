import 'dart:async';

import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/core/services/app_info_service.dart';
import 'package:beneathsos_app/core/settings/domain/app_settings.dart';
import 'package:beneathsos_app/core/settings/presentation/providers/settings_providers.dart';
import 'package:beneathsos_app/features/settings/presentation/mixins/settings_mixin.dart';
import 'package:beneathsos_app/features/settings/presentation/widgets/choice_row.dart';
import 'package:beneathsos_app/features/settings/presentation/widgets/settings_section.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rubble_core/rubble_core.dart';

/// Settings: language, what new searches and measuring use, the data on this phone, and about.
class SettingsScreen extends ConsumerWidget with SettingsMixin {
  /// Creates the screen.
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final settings = ref.watch(appSettingsProvider);
    final update = ref.read(updateSettingsProvider);
    final version = ref.watch(appVersionProvider).value;
    return BeneathScaffold(
      title: l10n.settingsTitle,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SettingsSection(
              title: l10n.settingsLanguage,
              children: [
                ChoiceRow<AppLanguage>(
                  label: l10n.settingsLanguageHint,
                  values: AppLanguage.values,
                  selected: settings.language,
                  labelOf: (v) => languageLabel(l10n, v),
                  onSelected: (v) => unawaited(update.language(v)),
                ),
              ],
            ),
            SettingsSection(
              title: l10n.settingsSearches,
              children: [
                ChoiceRow<String>(
                  label: l10n.settingsRubbleType,
                  values: rubbleTypes,
                  selected: settings.defaultProfile,
                  labelOf: (v) => rubbleTypeLabel(l10n, v),
                  onSelected: (v) => unawaited(update.defaultProfile(v)),
                ),
                ChoiceRow<double>(
                  label: l10n.settingsHeight,
                  values: rubbleHeightChoices,
                  selected: settings.defaultRubbleHeight.value,
                  labelOf: (v) => l10n.settingsHeightChip(v.round()),
                  onSelected: (v) =>
                      unawaited(update.defaultRubbleHeight(Meters(v))),
                ),
                ChoiceRow<int>(
                  label: l10n.settingsMeasure,
                  values: measureSecondsChoices,
                  selected: settings.measureDuration.inSeconds,
                  labelOf: l10n.settingsSeconds,
                  onSelected: (v) =>
                      unawaited(update.measureDuration(Duration(seconds: v))),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.circlesToggle),
                  value: settings.signalCircles,
                  onChanged: (v) => unawaited(update.signalCircles(shown: v)),
                ),
              ],
            ),
            SettingsSection(
              title: l10n.settingsData,
              children: [
                SecondaryButton(
                  label: l10n.settingsDeletePractice,
                  icon: Icons.school_rounded,
                  onPressed: () => unawaited(
                    deleteSearches(context, ref, practiceOnly: true),
                  ),
                ),
                const SizedBox(height: BeneathSpacing.sm),
                SecondaryButton(
                  label: l10n.settingsDeleteAll,
                  icon: Icons.delete_forever_rounded,
                  onPressed: () => unawaited(
                    deleteSearches(context, ref, practiceOnly: false),
                  ),
                ),
              ],
            ),
            SettingsSection(
              title: l10n.settingsAbout,
              children: [
                if (version != null)
                  Text(l10n.settingsVersion(version), style: text.bodyLarge),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.info_outline_rounded),
                  title: Text(l10n.settingsDisclaimer),
                  onTap: () => const AboutDisclaimerRoute().go(context),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: Text(l10n.settingsPrivacy),
                  onTap: () => const PrivacyRoute().go(context),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.description_outlined),
                  title: Text(l10n.settingsLicences),
                  onTap: () => const LicencesRoute().go(context),
                ),
                Text(l10n.homeIndependence, style: text.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
