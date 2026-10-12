import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';

/// Fine print: the independence statement and "Powered by Socrepho".
class HomeFooter extends StatelessWidget {
  /// Creates the footer.
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final style = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return Column(
      children: [
        Text(l10n.homeIndependence, style: style, textAlign: TextAlign.center),
        const SizedBox(height: BeneathSpacing.s),
        Text(l10n.poweredBy, style: style, textAlign: TextAlign.center),
      ],
    );
  }
}
