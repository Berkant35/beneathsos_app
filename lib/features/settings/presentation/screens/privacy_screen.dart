import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';

/// What BeneathSOS keeps and sends — offline, so shown in the app rather than on a web page.
class PrivacyScreen extends StatelessWidget {
  /// Creates the screen.
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return BeneathScaffold(
      title: l10n.settingsPrivacy,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final paragraph in [
              l10n.privacyNothing,
              l10n.privacyOnPhone,
              l10n.privacyExport,
              l10n.privacyBeacon,
            ]) ...[
              Text(paragraph, style: text.bodyLarge),
              const SizedBox(height: BeneathSpacing.m),
            ],
          ],
        ),
      ),
    );
  }
}
