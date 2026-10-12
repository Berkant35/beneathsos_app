import 'dart:async';

import 'package:beneathsos_app/core/canvas/canvas_style.dart';
import 'package:beneathsos_app/core/formatting/measures.dart';
import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:rubble_canvas/rubble_canvas.dart';
import 'package:rubble_core/rubble_core.dart';

/// The scale step: choose a side, type its real length, say how it was measured, Save or Skip.
class ScaleForm extends StatelessWidget {
  /// Creates the form.
  const ScaleForm({
    required this.outline,
    required this.scale,
    required this.side,
    required this.onSide,
    required this.lengthController,
    required this.errorText,
    required this.source,
    required this.sourceLabel,
    required this.onSource,
    required this.onSave,
    required this.onSkip,
    super.key,
  });

  /// The stored outline.
  final RubblePolygon outline;

  /// The current scale.
  final double scale;

  /// The chosen side.
  final int side;

  /// Another side was tapped.
  final ValueChanged<int> onSide;

  /// The typed real length.
  final TextEditingController lengthController;

  /// The error under the field, if any.
  final String? errorText;

  /// How it was measured.
  final ScaleSource source;

  /// Label of a source.
  final String Function(ScaleSource) sourceLabel;

  /// A source was chosen.
  final ValueChanged<ScaleSource> onSource;

  /// Save.
  final Future<void> Function() onSave;

  /// Skip.
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    String length(Meters m) => metresLabel(l10n, m);
    final shown = Meters(outline.edges[side].length.value * scale);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.scaleQuestion, style: text.titleMedium),
        Text(l10n.scalePickHint, style: text.bodyMedium),
        const SizedBox(height: BeneathSpacing.sm),
        SizedBox(
          height: 220,
          child: EdgePicker(
            outline: outline,
            selected: side,
            onSelected: onSide,
            style: canvasStyleOf(Theme.of(context)),
            scale: scale,
            lengthLabel: length,
            semanticLabel: l10n.scaleNow(length(shown)),
          ),
        ),
        Text(l10n.scaleNow(length(shown)), style: text.bodyLarge),
        const SizedBox(height: BeneathSpacing.m),
        TextField(
          controller: lengthController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: l10n.scaleLabel,
            suffixText: l10n.unitMetres,
            errorText: errorText,
            errorMaxLines: 3,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: BeneathSpacing.m),
        Semantics(
          header: true,
          child: Text(l10n.scaleHowTitle, style: text.titleMedium),
        ),
        RadioGroup<ScaleSource>(
          groupValue: source,
          onChanged: (value) {
            if (value != null) onSource(value);
          },
          child: Column(
            children: [
              for (final s in const [
                ScaleSource.tape,
                ScaleSource.steps,
                ScaleSource.estimate,
              ])
                RadioListTile<ScaleSource>(
                  value: s,
                  title: Text(sourceLabel(s)),
                ),
            ],
          ),
        ),
        const SizedBox(height: BeneathSpacing.l),
        PrimaryButton(
          label: l10n.scaleSave,
          icon: Icons.straighten_rounded,
          // Errors are shown under the field.
          onPressed: () => unawaited(onSave()),
        ),
        const SizedBox(height: BeneathSpacing.sm),
        SecondaryButton(label: l10n.scaleSkip, onPressed: onSkip),
      ],
    );
  }
}
