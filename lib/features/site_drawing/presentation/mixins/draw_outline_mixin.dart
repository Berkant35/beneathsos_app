import 'package:beneathsos_app/core/formatting/measures.dart';
import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/features/site_drawing/domain/save_outline_result.dart';
import 'package:beneathsos_app/features/site_drawing/presentation/providers/drawing_providers.dart';
import 'package:beneathsos_app/features/site_drawing/presentation/widgets/clear_outline_dialog.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rubble_canvas/rubble_canvas.dart';
import 'package:rubble_core/rubble_core.dart';

/// Text of the drawing screen.
mixin DrawOutlineMixin {
  /// "4 corners · perimeter 61.2 m · area 216 m²", or what is wrong with the outline. Lengths are
  /// multiplied by [scale], areas by its square.
  String summary(AppLocalizations l10n, OutlineDraft draft, double scale) {
    final polygon = draft.polygon;
    if (polygon != null) {
      return l10n.drawSummary(
        polygon.corners.length,
        metresLabel(l10n, Meters(polygon.perimeter.value * scale)),
        squareMetresLabel(
          l10n,
          SquareMeters(polygon.area.value * scale * scale),
        ),
      );
    }
    return switch (draft.problem) {
      TooFewCorners() || null => l10n.drawTooFew,
      CornersTooClose() => l10n.drawTooClose,
      SelfIntersecting() => l10n.drawCrossing,
      DegenerateOutline() => l10n.drawNoArea,
      NonFiniteCorner() => l10n.drawBadCorner,
    };
  }

  /// Stores the outline and opens the scale step; says so when it could not be stored.
  Future<void> finish(
    BuildContext context,
    WidgetRef ref,
    String sessionId,
  ) async {
    final result = await ref
        .read(outlineDraftControllerProvider(sessionId).notifier)
        .save();
    if (!context.mounted) return;
    switch (result) {
      case OutlineSaved():
        ScaleRoute(sessionId: sessionId).go(context);
      case OutlineNotSaved():
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.drawNotSaved)));
      case OutlineNotValid() || OutlineSaveRunning():
        break; // the summary already says what is wrong; a second tap waits
    }
  }

  /// Removes every corner — after asking, when there is an outline worth keeping.
  Future<void> clear(
    BuildContext context,
    WidgetRef ref,
    String sessionId,
    OutlineDraft draft,
  ) async {
    if (draft.corners.length >= 3 &&
        !await ClearOutlineDialog.confirm(context)) {
      return;
    }
    ref
        .read(outlineDraftControllerProvider(sessionId).notifier)
        .change(draft.clear());
  }
}
