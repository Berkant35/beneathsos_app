import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Pumps [home] with the BeneathSOS light theme and localisations.
Future<void> pumpLocalized(
  WidgetTester tester,
  Widget home, {
  Locale locale = const Locale('en'),
}) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      theme: BeneathTheme.light(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    ),
  );
  await tester.pumpAndSettle();
}

/// Like [pumpLocalized], with the system text size multiplied by [textScale].
Future<void> pumpLocalizedScaled(
  WidgetTester tester,
  Widget home, {
  required double textScale,
  Locale locale = const Locale('en'),
}) => pumpLocalized(
  tester,
  Builder(
    builder: (context) => MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: TextScaler.linear(textScale)),
      child: home,
    ),
  ),
  locale: locale,
);

/// Pumps the real routes at `/` with a given locale, text scale and theme.
Future<void> pumpRouterApp(
  WidgetTester tester, {
  Locale locale = const Locale('en'),
  double textScale = 1,
  ThemeData? theme,
}) async {
  final router = GoRouter(routes: $appRoutes);
  addTearDown(router.dispose);
  await tester.pumpWidget(
    MaterialApp.router(
      locale: locale,
      theme: theme ?? BeneathTheme.light(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// Sets a phone-sized view (logical [width] × [height] at 2×) for this test.
void setPhoneSize(WidgetTester tester, double width, double height) {
  tester.view
    ..physicalSize = Size(width * 2, height * 2)
    ..devicePixelRatio = 2;
  addTearDown(tester.view.reset);
}

/// Fails if the paragraph found by [text] is clipped (laid out shorter than its text) or cannot be
/// scrolled into a hit-testable position — clipping raises no overflow error, so check it directly.
Future<void> expectFullyReadable(WidgetTester tester, Finder text) async {
  final paragraph = tester.renderObject<RenderParagraph>(text);
  expect(
    paragraph.size.height,
    greaterThanOrEqualTo(
      paragraph.getMaxIntrinsicHeight(paragraph.size.width) - 0.5,
    ),
    reason: 'the paragraph is clipped',
  );
  await tester.ensureVisible(text);
  await tester.pumpAndSettle();
  expect(text.hitTestable(), findsOneWidget);
}
