import 'dart:async';

import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/features/onboarding/presentation/widgets/disclaimer_content.dart';
import 'package:beneathsos_app/features/preview/presentation/providers/practice_session.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Preview 1 — first-run notice: what the app does and does not do (legal disclaimer, rule 5).
class PreviewNoticeScreen extends ConsumerWidget {
  /// Creates the screen.
  const PreviewNoticeScreen({super.key});

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
              onPressed: () {
                // Queued in order and never throws (see PracticeSession).
                unawaited(
                  ref
                      .read(practiceSessionProvider.notifier)
                      .start(l10n.practiceTitle),
                );
                const PreviewSiteRoute().go(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
