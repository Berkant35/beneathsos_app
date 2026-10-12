import 'dart:async';

import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/features/measurement/domain/measurement_rules.dart';
import 'package:beneathsos_app/features/measurement/domain/measurement_state.dart';
import 'package:beneathsos_app/features/measurement/presentation/mixins/measure_mixin.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:rubble_core/rubble_core.dart';

/// Under the map: what to do now (tap where you are / hold still), progress per target, the last
/// result, the relink question and Discard.
class MeasurePanel extends StatelessWidget with MeasureMixin {
  /// Creates the panel.
  const MeasurePanel({
    required this.search,
    required this.state,
    required this.onDiscard,
    required this.onRelink,
    super.key,
  });

  /// The search.
  final SessionState search;

  /// Where measuring stands.
  final MeasurementState state;

  /// Discard this point.
  final Future<void> Function() onDiscard;

  /// The rescuer confirmed a relink.
  final Future<void> Function(RelinkSuggestion) onRelink;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: switch (state) {
        ChoosingPoint(:final last) => [
          if (last != null) ...[
            StatusBanner(
              kind: last is PointNotSaved
                  ? StatusKind.attention
                  : StatusKind.ready,
              message: outcome(l10n, last),
              icon: last is PointNotSaved ? null : Icons.check_circle_rounded,
            ),
            const SizedBox(height: BeneathSpacing.sm),
          ],
          StatusBanner(
            kind: StatusKind.ready,
            message: l10n.pointChoose,
            icon: Icons.touch_app_rounded,
          ),
          const SizedBox(height: BeneathSpacing.sm),
          Text(summary(l10n, search), style: text.bodyLarge),
          Text(l10n.mapLegend, style: text.bodySmall),
        ],
        final Measuring measuring => [
          Row(
            children: [
              CountdownRing(
                total: MeasurementPolicy.duration,
                remaining: measuring.remaining,
                semanticLabel: l10n.secondsLeft(measuring.remaining.inSeconds),
                size: 96,
              ),
              const SizedBox(width: BeneathSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.measureHold, style: text.titleMedium),
                    for (final line in targetLines(l10n, search, measuring))
                      Text(line),
                  ],
                ),
              ),
            ],
          ),
          if (measuring.moving) ...[
            const SizedBox(height: BeneathSpacing.sm),
            StatusBanner(
              kind: StatusKind.attention,
              message: l10n.pointMoving,
              icon: Icons.pan_tool_rounded,
            ),
          ],
          if (measuring.relink case final relink?) ...[
            const SizedBox(height: BeneathSpacing.sm),
            StatusBanner(
              kind: StatusKind.attention,
              message: l10n.relinkQuestion(relink.gapSeconds),
            ),
            const SizedBox(height: BeneathSpacing.s),
            SecondaryButton(
              label: l10n.relinkYes,
              icon: Icons.link_rounded,
              onPressed: () => unawaited(onRelink(relink)),
            ),
          ],
          const SizedBox(height: BeneathSpacing.m),
          SecondaryButton(
            label: l10n.measureDiscard,
            icon: Icons.delete_outline_rounded,
            onPressed: () => unawaited(onDiscard()),
          ),
        ],
      },
    );
  }
}
