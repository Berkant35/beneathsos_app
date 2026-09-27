import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:flutter/material.dart';

/// Asks for a marker text; returns it or null.
class MarkerDialog extends StatefulWidget {
  /// Creates the dialog.
  const MarkerDialog({super.key});

  /// Shows the dialog.
  static Future<String?> show(BuildContext context) => showDialog<String>(
    context: context,
    builder: (_) => const MarkerDialog(),
  );

  @override
  State<MarkerDialog> createState() => _MarkerDialogState();
}

class _MarkerDialogState extends State<MarkerDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.markerAdd),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(hintText: l10n.markerHint),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.actionCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text.trim()),
          child: Text(l10n.actionSave),
        ),
      ],
    );
  }
}
