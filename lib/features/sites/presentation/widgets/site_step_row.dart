import 'package:beneathsos_app/features/sites/presentation/mixins/site_screen_mixin.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';

/// One step of the search with its state, read as one item by screen readers.
class SiteStepRow extends StatelessWidget {
  /// Creates the row; [onTap] makes it a button (with a chevron).
  const SiteStepRow({required this.step, this.onTap, super.key});

  /// The step.
  final SiteStep step;

  /// Opens the step, if it can be opened.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onTap = this.onTap;
    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: BeneathSpacing.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            step.done
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: step.done
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
          ),
          const SizedBox(width: BeneathSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.label, style: theme.textTheme.titleMedium),
                Text(step.status, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          if (onTap != null)
            Icon(Icons.chevron_right_rounded, color: theme.colorScheme.primary),
        ],
      ),
    );
    return MergeSemantics(
      child: onTap == null
          ? row
          : Semantics(
              button: true,
              child: InkWell(
                onTap: onTap,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: BeneathSizes.minTouchTarget,
                  ),
                  child: row,
                ),
              ),
            ),
    );
  }
}
