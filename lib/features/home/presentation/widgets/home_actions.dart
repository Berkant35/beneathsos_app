import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';

/// The home screen's two actions, in the thumb zone. `go` (not `push`) makes a double tap harmless.
class HomeActions extends StatelessWidget {
  /// Creates the actions.
  const HomeActions({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryButton(
          label: l10n.homeStartSearch,
          icon: Icons.search_rounded,
          onPressed: () => const PreviewNoticeRoute().go(context),
        ),
        const SizedBox(height: BeneathSpacing.m),
        SecondaryButton(
          label: l10n.homeTrapped,
          onPressed: () => const VictimRoute().go(context),
        ),
      ],
    );
  }
}
