import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/widgets/app_scaffold.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';

/// Temporary home while the design system (roadmap phase 1) is built.
class HomeScreen extends StatelessWidget {
  /// Creates the home screen.
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return AppScaffold(
      title: l10n.appTitle,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.homeUnderConstructionTitle, style: text.headlineSmall),
            const SizedBox(height: BeneathSpacing.s),
            Text(
              l10n.homeUnderConstructionBody,
              textAlign: TextAlign.center,
              style: text.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
