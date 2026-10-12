import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';

/// What BeneathSOS does and does not do, and the independence note (legal disclaimer, rule 5).
class DisclaimerContent extends StatelessWidget {
  /// Creates the content.
  const DisclaimerContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BeneathCard(
          title: l10n.noticeDoesTitle,
          icon: Icons.info_outline_rounded,
          child: Text(l10n.noticeDoesBody, style: text.bodyLarge),
        ),
        const SizedBox(height: BeneathSpacing.m),
        BeneathCard(
          title: l10n.noticeDoesNotTitle,
          icon: Icons.warning_amber_rounded,
          child: Text(l10n.noticeDoesNotBody, style: text.bodyLarge),
        ),
        const SizedBox(height: BeneathSpacing.m),
        Text(l10n.homeIndependence, style: text.bodySmall),
      ],
    );
  }
}
