import 'package:beneathsos_app/core/canvas/canvas_style.dart';
import 'package:beneathsos_app/core/formatting/measures.dart';
import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/features/site_drawing/presentation/mixins/draw_outline_mixin.dart';
import 'package:beneathsos_app/features/site_drawing/presentation/providers/drawing_providers.dart';
import 'package:beneathsos_app/features/site_drawing/presentation/widgets/draw_controls.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rubble_canvas/rubble_canvas.dart';

/// The canvas (as large as possible) above the hint and the controls. At large text the hint and the
/// controls scroll inside at most half the screen, so the canvas never disappears and nothing
/// overflows.
class DrawOutlineBody extends ConsumerWidget with DrawOutlineMixin {
  /// Creates the body for [draft] of [sessionId], lengths multiplied by [scale].
  const DrawOutlineBody({
    required this.sessionId,
    required this.draft,
    required this.scale,
    super.key,
  });

  /// The search.
  final String sessionId;

  /// The outline being drawn.
  final OutlineDraft draft;

  /// Multiplier for drawn lengths.
  final double scale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final controller = ref.read(
      outlineDraftControllerProvider(sessionId).notifier,
    );
    final text = summary(l10n, draft, scale);
    final page = BeneathSpacing.pageFor(MediaQuery.sizeOf(context).width);
    return LayoutBuilder(
      builder: (context, constraints) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: OutlineEditor(
              draft: draft,
              onChanged: controller.change,
              style: canvasStyleOf(Theme.of(context)),
              scale: scale,
              lengthLabel: (m) => metresLabel(l10n, m),
              semanticLabel: text,
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: constraints.maxHeight / 2),
            child: SingleChildScrollView(
              padding: page.copyWith(top: BeneathSpacing.m),
              child: DrawControls(
                hint: l10n.drawHint,
                summary: text,
                valid: draft.polygon != null,
                onUndo: draft.canUndo
                    ? () => controller.change(draft.undo())
                    : null,
                onClear: draft.corners.isEmpty
                    ? null
                    : () => clear(context, ref, sessionId, draft),
                onDone: () => finish(context, ref, sessionId),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
