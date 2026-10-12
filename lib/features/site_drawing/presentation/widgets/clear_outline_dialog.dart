import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:flutter/material.dart';

/// Asks before every corner is removed (it can still be undone).
class ClearOutlineDialog extends StatelessWidget {
  /// Creates the dialog.
  const ClearOutlineDialog({super.key});

  /// Shows the dialog; true when the user confirmed.
  static Future<bool> confirm(BuildContext context) async =>
      await showDialog<bool>(
        context: context,
        builder: (_) => const ClearOutlineDialog(),
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.clearConfirmTitle),
      content: Text(l10n.clearConfirmBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.clearConfirmNo),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.clearConfirmYes),
        ),
      ],
    );
  }
}
