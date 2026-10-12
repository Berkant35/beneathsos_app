import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';

/// A search that does not exist (an old link): a calm message and a way back.
class SiteNotFound extends StatelessWidget {
  /// Creates the view.
  const SiteNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StatusBanner(kind: StatusKind.attention, message: l10n.siteNotFound),
        const SizedBox(height: BeneathSpacing.l),
        SecondaryButton(
          label: l10n.siteBackToList,
          onPressed: () => const SitesRoute().go(context),
        ),
      ],
    );
  }
}
