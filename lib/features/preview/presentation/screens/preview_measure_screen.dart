import 'dart:async';

import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/features/preview/presentation/providers/practice_session.dart';
import 'package:beneathsos_app/features/preview/presentation/widgets/preview_banner.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Preview 5 — 15 s point measurement: hold still; "no signal" is information.
class PreviewMeasureScreen extends ConsumerWidget {
  /// Creates the screen.
  const PreviewMeasureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return BeneathScaffold(
      title: l10n.measureTitle,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PreviewBanner(),
            const SizedBox(height: BeneathSpacing.l),
            Center(
              child: CountdownRing(
                total: const Duration(seconds: 15),
                remaining: const Duration(seconds: 9),
                semanticLabel: l10n.secondsLeft(9),
                size: 200,
              ),
            ),
            const SizedBox(height: BeneathSpacing.l),
            Text(
              l10n.measureHold,
              style: text.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: BeneathSpacing.l),
            StatusBanner(
              kind: StatusKind.ready,
              message: l10n.measureHeard,
              icon: Icons.graphic_eq_rounded,
            ),
            const SizedBox(height: BeneathSpacing.sm),
            StatusBanner(kind: StatusKind.ready, message: l10n.measureStill),
            const SizedBox(height: BeneathSpacing.xl),
            PrimaryButton(
              label: l10n.measureShowMap,
              icon: Icons.map_rounded,
              onPressed: () {
                // Queued in order and never throws (see PracticeSession).
                unawaited(
                  ref.read(practiceSessionProvider.notifier).pointMeasured(),
                );
                const PreviewMapRoute().go(context);
              },
            ),
            const SizedBox(height: BeneathSpacing.m),
            SecondaryButton(
              label: l10n.measureDiscard,
              // Queued in order and never throws (see PracticeSession).
              onPressed: () => unawaited(
                ref.read(practiceSessionProvider.notifier).pointDiscarded(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
