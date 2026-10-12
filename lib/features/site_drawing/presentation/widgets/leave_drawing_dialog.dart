import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:flutter/material.dart';

/// Asks before Back throws away corners that were not saved.
class LeaveDrawingDialog extends StatelessWidget {
  /// Creates the dialog.
  const LeaveDrawingDialog({super.key});

  /// Shows the dialog; true when the user chose to leave.
  static Future<bool> confirm(BuildContext context) async =>
      await showDialog<bool>(
        context: context,
        builder: (_) => const LeaveDrawingDialog(),
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.leaveDrawTitle),
      content: Text(l10n.leaveDrawBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.leaveDrawStay),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.leaveDrawLeave),
        ),
      ],
    );
  }
}
