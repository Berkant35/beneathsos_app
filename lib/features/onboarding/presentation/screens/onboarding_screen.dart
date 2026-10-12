import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/features/onboarding/presentation/providers/disclaimer.dart';
import 'package:beneathsos_app/features/onboarding/presentation/widgets/disclaimer_content.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// First run of the rescuer flow: the disclaimer, accepted once, then the list of searches.
class OnboardingScreen extends ConsumerWidget {
  /// Creates the screen.
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return BeneathScaffold(
      title: l10n.noticeTitle,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DisclaimerContent(),
            const SizedBox(height: BeneathSpacing.xl),
            PrimaryButton(
              label: l10n.noticeAccept,
              onPressed: () async {
                await ref.read(disclaimerProvider.notifier).accept();
                if (context.mounted) const SitesRoute().go(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
