import 'dart:async';

import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/features/preview/presentation/providers/practice_session.dart';
import 'package:beneathsos_app/features/preview/presentation/widgets/preview_banner.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Preview 4 — choose the target: candidates ranked with the reason in plain words.
class PreviewTargetScreen extends ConsumerWidget {
  /// Creates the screen.
  const PreviewTargetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final candidates = [
      (
        'Apple · Find My',
        l10n.targetReasonLikely,
        Icons.signal_cellular_alt_1_bar_rounded,
        true,
      ),
      (
        l10n.targetSamsung,
        l10n.targetReasonMedium,
        Icons.signal_cellular_alt_2_bar_rounded,
        false,
      ),
      (
        l10n.targetUnknown,
        l10n.targetReasonMoving,
        Icons.signal_cellular_alt_rounded,
        false,
      ),
    ];
    return BeneathScaffold(
      title: l10n.targetTitle,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PreviewBanner(),
            const SizedBox(height: BeneathSpacing.sm),
            StatusBanner(
              kind: StatusKind.ready,
              message: l10n.targetHint,
              icon: Icons.phonelink_ring_rounded,
            ),
            const SizedBox(height: BeneathSpacing.m),
            for (final (name, reason, signal, selected) in candidates) ...[
              BeneathCard(
                title: name,
                icon: selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_unchecked_rounded,
                onTap: () {},
                child: Row(
                  children: [
                    Icon(signal, color: scheme.primary),
                    const SizedBox(width: BeneathSpacing.s),
                    Expanded(child: Text(reason)),
                  ],
                ),
              ),
              const SizedBox(height: BeneathSpacing.sm),
            ],
            const SizedBox(height: BeneathSpacing.m),
            PrimaryButton(
              label: l10n.targetTrack,
              icon: Icons.track_changes_rounded,
              onPressed: () {
                // Queued in order and never throws (see PracticeSession).
                unawaited(
                  ref.read(practiceSessionProvider.notifier).targetChosen(),
                );
                const PreviewMeasureRoute().go(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
