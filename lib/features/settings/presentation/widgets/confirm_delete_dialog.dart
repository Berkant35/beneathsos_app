import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:flutter/material.dart';

/// Asks before searches are deleted.
class ConfirmDeleteDialog extends StatelessWidget {
  /// Creates the dialog.
  const ConfirmDeleteDialog({
    required this.title,
    required this.body,
    super.key,
  });

  /// The question.
  final String title;

  /// What will happen.
  final String body;

  /// Shows the dialog; true when the person chose to delete.
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String body,
  }) async =>
      await showDialog<bool>(
        context: context,
        builder: (_) => ConfirmDeleteDialog(title: title, body: body),
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.settingsDeleteKeep),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: Text(l10n.settingsDeleteConfirm),
        ),
      ],
    );
  }
}
