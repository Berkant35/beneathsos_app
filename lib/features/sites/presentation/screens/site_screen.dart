import 'dart:async';

import 'package:beneathsos_app/core/formatting/date_labels.dart';
import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/sessions/presentation/widgets/finish_search_dialog.dart';
import 'package:beneathsos_app/features/sites/presentation/mixins/site_screen_mixin.dart';
import 'package:beneathsos_app/features/sites/presentation/providers/searches.dart';
import 'package:beneathsos_app/features/sites/presentation/widgets/site_not_found.dart';
import 'package:beneathsos_app/features/sites/presentation/widgets/site_step_row.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One search: its name, when it started, the steps of the rescuer flow and Finish.
class SiteScreen extends ConsumerWidget with SiteScreenMixin {
  /// Creates the screen for [sessionId].
  const SiteScreen({required this.sessionId, super.key});

  /// The search.
  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final searches = ref.watch(searchesProvider);
    final search = searches.value
        ?.where((s) => s.id.value == sessionId)
        .firstOrNull;
    final state = ref.watch(searchStateProvider(sessionId));
    return BeneathScaffold(
      title: l10n.searchTitle,
      body: SingleChildScrollView(
        child: switch ((searches.hasValue, search)) {
          (false, _) => const SizedBox.shrink(),
          (true, null) => const SiteNotFound(),
          (true, final search?) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                header: true,
                child: Text(search.title, style: text.headlineSmall),
              ),
              Text(
                l10n.siteStarted(dayAndTime(search.createdAt, l10n.localeName)),
                style: text.bodyMedium,
              ),
              const SizedBox(height: BeneathSpacing.m),
              if (state.hasError) ...[
                StatusBanner(
                  kind: StatusKind.attention,
                  message: l10n.siteUnreadable,
                ),
                const SizedBox(height: BeneathSpacing.m),
              ],
              if (search.closedAt != null) ...[
                StatusBanner(
                  kind: StatusKind.ready,
                  message: l10n.siteFinished,
                  icon: Icons.flag_rounded,
                ),
                const SizedBox(height: BeneathSpacing.m),
              ],
              for (final step in stepsFor(l10n, state.value))
                SiteStepRow(step: step),
              if (search.closedAt == null) ...[
                const SizedBox(height: BeneathSpacing.xl),
                SecondaryButton(
                  label: l10n.lastSearchFinish,
                  icon: Icons.flag_rounded,
                  // Asks first; errors are logged; the screen updates from the database.
                  onPressed: () => unawaited(
                    FinishSearchDialog.confirmAndFinish(
                      context,
                      ref,
                      search.id,
                    ),
                  ),
                ),
              ],
            ],
          ),
        },
      ),
    );
  }
}
