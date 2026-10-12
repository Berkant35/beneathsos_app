import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';

/// Standard screen frame: optional app bar from [title], safe area, page padding, max width on
/// tablets. Use a raw `Scaffold` only for full-bleed screens and say why.
class AppScaffold extends StatelessWidget {
  /// Creates a screen frame; without [title] there is no app bar (e.g. the home screen).
  const AppScaffold({
    required this.body,
    this.title,
    this.actions = const [],
    this.bottom,
    this.padded = true,
    super.key,
  });

  /// App bar title; null hides the app bar.
  final String? title;

  /// Screen content.
  final Widget body;

  /// App bar actions.
  final List<Widget> actions;

  /// Optional app bar bottom (e.g. a TabBar).
  final PreferredSizeWidget? bottom;

  /// Whether page padding is applied.
  final bool padded;

  static const double _maxWidth = 720;

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    return Scaffold(
      appBar: title == null
          ? null
          : AppBar(title: Text(title), actions: actions, bottom: bottom),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxWidth),
            child: padded
                ? Padding(
                    padding: BeneathSpacing.pageFor(
                      MediaQuery.sizeOf(context).width,
                    ),
                    child: body,
                  )
                : body,
          ),
        ),
      ),
    );
  }
}
