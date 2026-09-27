import 'package:flutter/material.dart';

/// High-contrast themes: the app is used outdoors, in dust and sunlight.
abstract final class AppTheme {
  static const _seed = Color(0xFFE65100);

  /// Light theme.
  static ThemeData light() => _build(Brightness.light);

  /// Dark theme.
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
      contrastLevel: 0.5,
    );
    return ThemeData(
      colorScheme: scheme,
      visualDensity: VisualDensity.standard,
      listTileTheme: const ListTileThemeData(minVerticalPadding: 10),
    );
  }
}

/// Spacing tokens.
abstract final class AppSpacing {
  /// 4 px.
  static const double xs = 4;

  /// 8 px.
  static const double s = 8;

  /// 16 px.
  static const double m = 16;

  /// 24 px.
  static const double l = 24;

  /// Page padding.
  static const EdgeInsets page = EdgeInsets.all(m);
}
