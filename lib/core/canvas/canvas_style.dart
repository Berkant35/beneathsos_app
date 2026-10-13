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

/// One colour per signal circle (in measuring order): far from the safety orange of the regions and the
/// suggestion, and distinct from each other in light and dark.
const signalCircleColors = <Color>[
  Color(0xFFE53935), // red
  Color(0xFF7E57C2), // violet
  Color(0xFF00897B), // teal
  Color(0xFF1E88E5), // blue
  Color(0xFFD81B60), // pink
  Color(0xFF43A047), // green
  Color(0xFFFDD835), // yellow
  Color(0xFF8D6E63), // brown
];
