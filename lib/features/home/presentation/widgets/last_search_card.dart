import 'dart:async';

import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/logging/app_logger.dart';
import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/features/home/presentation/mixins/last_search_card_mixin.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The newest search that was not finished — it survives the app being killed — with Continue
/// and Finish. Nothing while there is none.
class LastSearchCard extends ConsumerWidget with LastSearchCardMixin {
  /// Creates the card.
  const LastSearchCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(latestOpenSessionProvider, (_, next) {
      if (next case AsyncError(:final error, :final stackTrace)) {
        AppLogger.error(
          'home',
          'Could not read the last search',
          error,
          stackTrace,
        );
      }
    });
    final search = ref.watch(latestOpenSessionProvider).value;
    if (search == null) return const SizedBox.shrink();
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(bottom: BeneathSpacing.m),
      child: BeneathCard(
        title: cardTitle(l10n, search),
        icon: Icons.history_rounded,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(cardBody(l10n, search)),
            const SizedBox(height: BeneathSpacing.m),
            SecondaryButton(
              label: l10n.lastSearchContinue,
              icon: Icons.play_arrow_rounded,
              onPressed: () => continueSearch(context, ref, search),
            ),
            const SizedBox(height: BeneathSpacing.sm),
            SecondaryButton(
              label: l10n.lastSearchFinish,
              icon: Icons.flag_rounded,
              // Errors are logged inside; the card updates from the database.
              onPressed: () => unawaited(finishSearch(ref, search)),
            ),
          ],
        ),
      ),
    );
  }
}
