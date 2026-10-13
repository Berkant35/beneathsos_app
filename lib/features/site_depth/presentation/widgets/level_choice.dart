import 'package:beneathsos_app/core/formatting/levels.dart';
import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:rubble_core/rubble_core.dart';

/// Where the person most likely was: one choice of [TrappedLevel].
class LevelChoice extends StatelessWidget {
  /// Creates the choice showing [value].
  const LevelChoice({required this.value, required this.onChanged, super.key});

  /// The level chosen.
  final TrappedLevel value;

  /// A level was chosen.
  final ValueChanged<TrappedLevel> onChanged;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: BeneathSpacing.sm,
    runSpacing: BeneathSpacing.sm,
    children: [
      for (final level in TrappedLevel.values)
        ChoiceChip(
          label: Text(levelLabel(context.l10n, level)),
          selected: level == value,
          onSelected: (_) => onChanged(level),
        ),
    ],
  );
}
