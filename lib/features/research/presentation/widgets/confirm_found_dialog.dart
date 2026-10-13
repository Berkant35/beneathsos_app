import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:flutter/material.dart';

/// Asks before a spot is recorded as where the phone was found — on a live search a mistaken record
/// would tell the team the phone was recovered.
class ConfirmFoundDialog extends StatelessWidget {
  /// Creates the dialog.
  const ConfirmFoundDialog({super.key});

  /// Shows the dialog; true when the person confirmed.
  static Future<bool> confirm(BuildContext context) async =>
      await showDialog<bool>(
        context: context,
        builder: (_) => const ConfirmFoundDialog(),
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.probConfirmFoundTitle),
      content: Text(l10n.probConfirmFoundBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.probConfirmFoundNo),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.probConfirmFoundYes),
        ),
      ],
    );
  }
}
