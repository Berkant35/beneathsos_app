import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

/// Start of the rescuer flow. "Being prepared" until roadmap phase 4 replaces it on the same route.
class NewSiteScreen extends StatelessWidget {
  /// Creates the screen.
  const NewSiteScreen({super.key});

  @override
  Widget build(BuildContext context) => AppScaffold(
    title: context.l10n.newSiteTitle,
    // Scrolls so large system text is never cut off (no overflow error would reveal it).
    body: SingleChildScrollView(
      child: Text(
        context.l10n.newSitePreparing,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    ),
  );
}
