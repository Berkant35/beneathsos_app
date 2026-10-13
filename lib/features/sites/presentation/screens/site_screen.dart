import 'dart:async';

import 'package:beneathsos_app/core/formatting/date_labels.dart';
import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/core/sessions/presentation/mixins/finish_search_mixin.dart';
import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/features/sites/presentation/mixins/site_screen_mixin.dart';
import 'package:beneathsos_app/features/sites/presentation/providers/searches.dart';
import 'package:beneathsos_app/features/sites/presentation/widgets/site_not_found.dart';
import 'package:beneathsos_app/features/sites/presentation/widgets/site_step_row.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One search: its name, when it started, the steps of the rescuer flow and Finish.
class SiteScreen extends ConsumerWidget
    with SiteScreenMixin, FinishSearchMixin {
  /// Creates the screen for [sessionId].
  const SiteScreen({required this.sessionId, super.key});

  /// The search.
  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final summary = ref.watch(searchSummaryProvider(sessionId));
    final state = ref.watch(sessionStateProvider(sessionId));
    return BeneathScaffold(
      title: l10n.searchTitle,
      body: SingleChildScrollView(
        // Riverpod retries a failed stream: the state is then "loading with an error", so decide by
        // hasError, not by the AsyncError type.
        child: switch (summary) {
          _ when summary.hasError => const SiteNotFound(),
          AsyncData(value: null) => const SiteNotFound(),
          AsyncData(value: final search?) => Column(
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
              for (final step in stepsFor(
                l10n,
                state.value,
                open: search.closedAt == null,
              ))
                SiteStepRow(
                  step: step,
                  onTap: switch (step.action) {
                    SiteStepAction.draw => () => DrawOutlineRoute(
                      sessionId: sessionId,
                    ).go(context),
                    SiteStepAction.depth => () => DepthRoute(
                      sessionId: sessionId,
                    ).go(context),
                    SiteStepAction.ambient => () => AmbientRoute(
                      sessionId: sessionId,
                    ).go(context),
                    SiteStepAction.target => () => TargetsRoute(
                      sessionId: sessionId,
                    ).go(context),
                    SiteStepAction.measure => () => MeasureRoute(
                      sessionId: sessionId,
                    ).go(context),
                    null => null,
                  },
                ),
              if (canOpenMap(state.value)) ...[
                const SizedBox(height: BeneathSpacing.m),
                PrimaryButton(
                  label: l10n.siteOpenMap,
                  icon: Icons.map_rounded,
                  onPressed: () => MapRoute(sessionId: sessionId).go(context),
                ),
              ],
              const SizedBox(height: BeneathSpacing.m),
              SecondaryButton(
                label: l10n.siteExport,
                icon: Icons.ios_share_rounded,
                onPressed: () => ExportRoute(sessionId: sessionId).go(context),
              ),
              if (search.closedAt == null) ...[
                const SizedBox(height: BeneathSpacing.xl),
                SecondaryButton(
                  label: l10n.lastSearchFinish,
                  icon: Icons.flag_rounded,
                  // Asks first; a failure is shown; the screen updates from the database.
                  onPressed: () =>
                      unawaited(confirmAndFinish(context, ref, search.id)),
                ),
              ],
            ],
          ),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}
