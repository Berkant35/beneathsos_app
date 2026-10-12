import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:flutter/material.dart';

/// Asks before a scale that changes every length a lot (probably a typo) is stored.
class UnusualScaleDialog extends StatelessWidget {
  /// Creates the dialog; [factor] and [real] are already formatted.
  const UnusualScaleDialog({
    required this.factor,
    required this.real,
    super.key,
  });

  /// "11.3".
  final String factor;

  /// "180.0 m".
  final String real;

  /// Shows the dialog; true when the user wants to save anyway.
  static Future<bool> confirm(
    BuildContext context, {
    required String factor,
    required String real,
  }) async =>
      await showDialog<bool>(
        context: context,
        builder: (_) => UnusualScaleDialog(factor: factor, real: real),
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.scaleConfirmTitle),
      content: Text(l10n.scaleConfirmBody(factor, real)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.scaleConfirmFix),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.scaleConfirmSave),
        ),
      ],
    );
  }
}
