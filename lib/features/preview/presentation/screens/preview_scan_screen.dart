import 'dart:async';

import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/features/preview/presentation/providers/practice_session.dart';
import 'package:beneathsos_app/features/preview/presentation/widgets/preview_banner.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Preview 3 — 30 s ambient scan: surface phones are listed so they are never suggested.
class PreviewScanScreen extends ConsumerWidget {
  /// Creates the screen.
  const PreviewScanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return BeneathScaffold(
      title: l10n.scanTitle,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PreviewBanner(),
            const SizedBox(height: BeneathSpacing.l),
            Center(
              child: CountdownRing(
                total: const Duration(seconds: 30),
                remaining: const Duration(seconds: 18),
                semanticLabel: l10n.secondsLeft(18),
                size: 200,
              ),
            ),
            const SizedBox(height: BeneathSpacing.l),
            Text(
              l10n.scanStand,
              style: text.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: BeneathSpacing.s),
            Text(
              l10n.scanBody,
              style: text.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: BeneathSpacing.l),
            BeneathCard(
              title: l10n.scanFound,
              icon: Icons.phone_iphone_rounded,
              child: Text('7', style: BeneathTokens.of(context).numeric),
            ),
            const SizedBox(height: BeneathSpacing.l),
            PrimaryButton(
              label: l10n.scanContinue,
              onPressed: () {
                // Queued in order and never throws (see PracticeSession).
                unawaited(
                  ref.read(practiceSessionProvider.notifier).ambientScanned(),
                );
                const PreviewTargetRoute().go(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
