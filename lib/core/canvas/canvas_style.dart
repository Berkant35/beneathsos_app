import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:rubble_canvas/rubble_canvas.dart';

/// The drawing canvas in the app's colours (light or dark).
RubbleCanvasStyle canvasStyleOf(ThemeData theme) {
  final scheme = theme.colorScheme;
  return RubbleCanvasStyle(
    background: scheme.surface,
    gridMinor: scheme.outlineVariant.withValues(alpha: 0.5),
    gridMajor: scheme.outlineVariant,
    outline: scheme.primary,
    corner: scheme.primary,
    // A thick line is a fill: the safety orange is allowed here (never for text or icons).
    highlight: theme.extension<BeneathTokens>()!.accent,
    label: theme.textTheme.labelLarge!.copyWith(color: scheme.onSurface),
    labelBackground: scheme.surface,
  );
}
