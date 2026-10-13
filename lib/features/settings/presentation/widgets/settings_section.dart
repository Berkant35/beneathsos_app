import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';

/// A titled group of settings.
class SettingsSection extends StatelessWidget {
  /// Creates the section [title] with [children].
  const SettingsSection({
    required this.title,
    required this.children,
    super.key,
  });

  /// Section title.
  final String title;

  /// Its settings.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: BeneathSpacing.l),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: BeneathSpacing.sm),
        ...children,
      ],
    ),
  );
}
