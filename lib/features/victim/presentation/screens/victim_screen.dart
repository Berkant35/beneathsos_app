import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/widgets/app_scaffold.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';

/// Victim mode. Until phase 10 it only tells a trapped person to call 112 — never an empty screen.
class VictimScreen extends StatelessWidget {
  /// Creates the screen.
  const VictimScreen({super.key});

  @override
  Widget build(BuildContext context) => AppScaffold(
    title: context.l10n.victimTitle,
    // Scrolls so large system text is never cut off (no overflow error would reveal it).
    body: SingleChildScrollView(
      child: BeneathCard(
        title: context.l10n.preparingCardTitle,
        icon: Icons.construction_rounded,
        child: Text(
          context.l10n.victimPreparing,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    ),
  );
}
