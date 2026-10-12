import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/features/onboarding/presentation/providers/disclaimer.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The home screen's two actions, in the thumb zone. `go` (not `push`) makes a double tap harmless.
class HomeActions extends ConsumerWidget {
  /// Creates the actions.
  const HomeActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Loads whether the disclaimer was accepted, so "Start a search" knows where to go.
    ref.watch(disclaimerProvider);
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryButton(
          label: l10n.homeStartSearch,
          icon: Icons.search_rounded,
          onPressed: () => const SitesRoute().go(context),
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
