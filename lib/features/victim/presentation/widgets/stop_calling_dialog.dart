import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:flutter/material.dart';

/// Asks before Back ends the help signal.
class StopCallingDialog extends StatelessWidget {
  /// Creates the dialog.
  const StopCallingDialog({super.key});

  /// Shows the dialog; true when the user chose to stop.
  static Future<bool> confirm(BuildContext context) async =>
      await showDialog<bool>(
        context: context,
        builder: (_) => const StopCallingDialog(),
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.victimStopTitle),
      content: Text(l10n.victimStopBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.victimKeep),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.victimStop),
        ),
      ],
    );
  }
}
