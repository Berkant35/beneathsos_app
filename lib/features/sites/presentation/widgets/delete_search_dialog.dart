import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:flutter/material.dart';

/// Asks before a search and everything recorded in it is deleted.
class DeleteSearchDialog extends StatelessWidget {
  /// Creates the dialog for the search named [title].
  const DeleteSearchDialog({required this.title, super.key});

  /// The search's name.
  final String title;

  /// Shows the dialog; true when the person chose to delete.
  static Future<bool> confirm(BuildContext context, String title) async =>
      await showDialog<bool>(
        context: context,
        builder: (_) => DeleteSearchDialog(title: title),
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.searchDeleteTitle(title)),
      content: Text(l10n.searchDeleteBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.searchDeleteKeep),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: Text(l10n.searchDeleteConfirm),
        ),
      ],
    );
  }
}
