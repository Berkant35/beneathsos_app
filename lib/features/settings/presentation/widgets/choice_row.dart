import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';

/// A labelled row of chips, one of [values] chosen.
class ChoiceRow<T> extends StatelessWidget {
  /// Creates the row.
  const ChoiceRow({
    required this.label,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
    super.key,
  });

  /// What is being chosen.
  final String label;

  /// The choices.
  final List<T> values;

  /// The current choice.
  final T selected;

  /// A choice's label.
  final String Function(T value) labelOf;

  /// A choice was made.
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: BeneathSpacing.m),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: BeneathSpacing.s),
        Wrap(
          spacing: BeneathSpacing.sm,
          runSpacing: BeneathSpacing.sm,
          children: [
            for (final value in values)
              ChoiceChip(
                label: Text(labelOf(value)),
                selected: value == selected,
                onSelected: (_) => onSelected(value),
              ),
          ],
        ),
      ],
    ),
  );
}
