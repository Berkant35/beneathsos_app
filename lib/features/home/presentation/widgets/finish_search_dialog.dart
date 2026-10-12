import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:flutter/material.dart';

/// Asks before a search is finished: it cannot be continued afterwards (its data stays).
class FinishSearchDialog extends StatelessWidget {
  /// Creates the dialog.
  const FinishSearchDialog({super.key});

  /// Shows the dialog; true when the user confirmed.
  static Future<bool> confirm(BuildContext context) async =>
      await showDialog<bool>(
        context: context,
        builder: (_) => const FinishSearchDialog(),
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.finishConfirmTitle),
      content: Text(l10n.finishConfirmBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.finishConfirmNo),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.finishConfirmYes),
        ),
      ],
    );
  }
}
