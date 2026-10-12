import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/features/probability_map/domain/map_request.dart';
import 'package:beneathsos_app/features/probability_map/presentation/mixins/map_mixin.dart';
import 'package:beneathsos_app/features/probability_map/presentation/providers/map_providers.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';

/// Under the map: the areas, the rule, low information, points left out, the legend and Measure next
/// point.
class MapPanel extends StatelessWidget with MapMixin {
  /// Creates the panel.
  const MapPanel({required this.sessionId, required this.map, super.key});

  /// The search.
  final String sessionId;

  /// The map of the selected target.
  final TargetMap map;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          liveRegion: true,
          child: Text(areas(l10n, map.result.map), style: text.titleMedium),
        ),
        Text(l10n.probRule, style: text.bodyMedium),
        if (map.lowInformation) ...[
          const SizedBox(height: BeneathSpacing.sm),
          StatusBanner(
            kind: StatusKind.attention,
            message: l10n.probLowInfo(minHeardPoints),
          ),
        ],
        if (map.onRubble > 0) ...[
          const SizedBox(height: BeneathSpacing.sm),
          StatusBanner(
            kind: StatusKind.attention,
            message: l10n.probOnRubble(map.onRubble),
          ),
        ],
        const SizedBox(height: BeneathSpacing.sm),
        Text(l10n.probLegend, style: text.bodySmall),
        const SizedBox(height: BeneathSpacing.m),
        PrimaryButton(
          label: l10n.probMeasureNext,
          icon: Icons.sensors_rounded,
          onPressed: () => MeasureRoute(sessionId: sessionId).go(context),
        ),
      ],
    );
  }
}
