import 'dart:async';

import 'package:beneathsos_app/core/canvas/canvas_style.dart';
import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/features/measurement/domain/measurement_state.dart';
import 'package:beneathsos_app/features/measurement/presentation/mixins/measure_mixin.dart';
import 'package:beneathsos_app/features/measurement/presentation/providers/measurement_providers.dart';
import 'package:beneathsos_app/features/measurement/presentation/widgets/measure_panel.dart';
import 'package:beneathsos_app/features/targets/presentation/providers/target_providers.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rubble_canvas/rubble_canvas.dart';

/// Measure at points around the rubble (roadmap 7): tap where you stand, hold still 15 s, every point
/// is stored — heard or not (rule 3). The map runs edge to edge (`padded: false`).
class MeasureScreen extends ConsumerWidget with MeasureMixin {
  /// Creates the screen for [sessionId].
  const MeasureScreen({required this.sessionId, super.key});

  /// The search.
  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final search = ref.watch(sessionStateProvider(sessionId)).value;
    final outline = search?.outline;
    final ready = outline != null && search!.targets.isNotEmpty;
    if (ready) ref.watch(scanWhileOpenProvider);
    final state = ready
        ? ref.watch(measurementControllerProvider(sessionId))
        : const ChoosingPoint();
    // Only read when measuring is possible: reading creates the controller.
    MeasurementController controller() =>
        ref.read(measurementControllerProvider(sessionId).notifier);
    final page = BeneathSpacing.pageFor(MediaQuery.sizeOf(context).width);
    return BeneathScaffold(
      title: l10n.pointTitle,
      padded: false,
      body: search == null
          ? const SizedBox.shrink()
          : !ready
          ? Padding(
              padding: page,
              child: StatusBanner(
                kind: StatusKind.attention,
                message: outline == null
                    ? l10n.pointNeedsOutline
                    : l10n.pointNeedsTarget,
                onTap: () => outline == null
                    ? DrawOutlineRoute(sessionId: sessionId).go(context)
                    : TargetsRoute(sessionId: sessionId).go(context),
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SiteMap(
                      outline: outline,
                      points: mapPoints(search, state),
                      style: canvasStyleOf(Theme.of(context)),
                      semanticLabel: summary(l10n, search),
                      onTap: state is ChoosingPoint
                          ? (at) => unawaited(controller().place(at))
                          : null,
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: constraints.maxHeight / 2,
                    ),
                    child: SingleChildScrollView(
                      padding: page.copyWith(top: BeneathSpacing.m),
                      child: MeasurePanel(
                        search: search,
                        state: state,
                        onDiscard: () => controller().discard(),
                        onRelink: (relink) => controller().relink(relink),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
