import 'package:beneathsos_app/core/disclaimer/disclaimer_content.dart';
import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';

/// The disclaimer again, to read (it was accepted once on the first search).
class AboutDisclaimerScreen extends StatelessWidget {
  /// Creates the screen.
  const AboutDisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context) => BeneathScaffold(
    title: context.l10n.settingsDisclaimer,
    body: const SingleChildScrollView(child: DisclaimerContent()),
  );
}
