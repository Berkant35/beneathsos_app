import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';
import 'package:beneathsos_app/core/scanning/presentation/providers/scanning_providers.dart';
import 'package:beneathsos_app/core/services/app_lifecycle.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../core/scanning/fakes.dart';

/// Fake hardware ports for widget tests (a real BleService needs the platform plugin).
List<Override> fakePortOverrides({
  FakeScanner? scanner,
  FakePermissions? permissions,
}) => [
  scannerPortProvider.overrideWithValue(scanner ?? FakeScanner()),
  scanPermissionPortProvider.overrideWithValue(
    permissions ?? FakePermissions(checkResult: ScanPermission.granted),
  ),
  appLifecycleProvider.overrideWith((ref) => const Stream.empty()),
];

/// Pumps [home] with the BeneathSOS light theme and localisations.
Future<void> pumpLocalized(
  WidgetTester tester,
  Widget home, {
  Locale locale = const Locale('en'),
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: fakePortOverrides(),
      child: MaterialApp(
        locale: locale,
        theme: BeneathTheme.light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: home,
      ),
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
  FakeScanner? scanner,
  FakePermissions? permissions,
}) async {
  final router = GoRouter(routes: $appRoutes);
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: fakePortOverrides(scanner: scanner, permissions: permissions),
      child: MaterialApp.router(
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
