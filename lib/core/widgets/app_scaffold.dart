import 'package:beneathsos_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Standard screen frame: app bar from [title], safe area, page padding, max width on tablets.
/// Use a raw `Scaffold` only for full-bleed screens and say why.
class AppScaffold extends StatelessWidget {
  /// Creates a screen frame.
  const AppScaffold({
    required this.title,
    required this.body,
    this.actions = const [],
    this.bottom,
    this.padded = true,
    super.key,
  });

  /// App bar title.
  final String title;

  /// Screen content.
  final Widget body;

  /// App bar actions.
  final List<Widget> actions;

  /// Optional app bar bottom (e.g. a TabBar).
  final PreferredSizeWidget? bottom;

  /// Whether [AppSpacing.page] is applied.
  final bool padded;

  static const double _maxWidth = 720;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title), actions: actions, bottom: bottom),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxWidth),
          child: padded ? Padding(padding: AppSpacing.page, child: body) : body,
        ),
      ),
    ),
  );
}
