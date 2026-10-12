import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
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
