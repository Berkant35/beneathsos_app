import 'dart:async';

import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';

/// Under the canvas: how to draw, the outline summary (or what is wrong), Undo, Clear and Outline
/// done.
class DrawControls extends StatelessWidget {
  /// Creates the controls.
  const DrawControls({
    required this.hint,
    required this.summary,
    required this.valid,
    required this.onUndo,
    required this.onClear,
    required this.onDone,
    super.key,
  });

  /// How to draw.
  final String hint;

  /// Corners, perimeter and area — or the problem.
  final String summary;

  /// Whether the outline can be stored.
  final bool valid;

  /// Undo, or null when there is nothing to undo.
  final VoidCallback? onUndo;

  /// Clear, or null when there are no corners.
  final Future<void> Function()? onClear;

  /// Outline done.
  final Future<void> Function() onDone;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final onClear = this.onClear;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StatusBanner(
          kind: StatusKind.ready,
          message: hint,
          icon: Icons.touch_app_rounded,
        ),
        const SizedBox(height: BeneathSpacing.sm),
        Semantics(
          liveRegion: true,
          child: Text(summary, style: Theme.of(context).textTheme.bodyLarge),
        ),
        const SizedBox(height: BeneathSpacing.m),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SecondaryButton(
                label: l10n.drawUndo,
                icon: Icons.undo_rounded,
                onPressed: onUndo,
              ),
            ),
            const SizedBox(width: BeneathSpacing.sm),
            Expanded(
              child: SecondaryButton(
                label: l10n.drawClear,
                icon: Icons.delete_sweep_rounded,
                onPressed: onClear == null ? null : () => unawaited(onClear()),
              ),
            ),
          ],
        ),
        const SizedBox(height: BeneathSpacing.sm),
        PrimaryButton(
          label: l10n.siteDone,
          icon: Icons.check_rounded,
          // Errors are shown by the screen.
          onPressed: valid ? () => unawaited(onDone()) : null,
        ),
      ],
    );
  }
}
