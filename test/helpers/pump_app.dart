import 'package:beneathsos_app/core/database/app_database.dart';
import 'package:beneathsos_app/core/database/database_provider.dart';
import 'package:beneathsos_app/core/models/ble_sample.dart';
import 'package:beneathsos_app/core/router/app_router.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';
import 'package:beneathsos_app/core/scanning/presentation/providers/scanning_providers.dart';
import 'package:beneathsos_app/core/sensors/domain/motion_port.dart';
import 'package:beneathsos_app/core/services/app_lifecycle.dart';
import 'package:beneathsos_app/core/services/ble_service.dart';
import 'package:beneathsos_app/core/services/motion_service.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../core/scanning/fakes.dart';

/// An in-memory database for widget tests. Streams close synchronously, so no drift timer is left
/// pending when the widget tree is disposed.
AppDatabase testDatabase() => AppDatabase(
  DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true),
);

/// Fake hardware ports for widget tests (a real BleService needs the platform plugin) and an
/// in-memory database ([database], or a fresh one closed with the scope).
List<Override> fakePortOverrides({
  FakeScanner? scanner,
  FakePermissions? permissions,
  AppDatabase? database,
  Stream<List<BleSample>>? samples,
  Stream<AppLifecycleState>? lifecycle,
  Stream<double>? motion,
}) => [
  motionPortProvider.overrideWithValue(_FakeMotion(motion)),
  bleSamplesProvider.overrideWith((ref) => samples ?? const Stream.empty()),
  screenAwakePortProvider.overrideWithValue(FakeScreen()),
  if (database != null)
    appDatabaseProvider.overrideWithValue(database)
  else
    appDatabaseProvider.overrideWith((ref) {
      final db = testDatabase();
      ref.onDispose(db.close);
      return db;
    }),
  scannerPortProvider.overrideWithValue(scanner ?? FakeScanner()),
  scanPermissionPortProvider.overrideWithValue(
    permissions ?? FakePermissions(checkResult: ScanPermission.granted),
  ),
  appLifecycleProvider.overrideWith((ref) => lifecycle ?? const Stream.empty()),
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
  AppDatabase? database,
  Stream<List<BleSample>>? samples,
  Stream<AppLifecycleState>? lifecycle,
  Stream<double>? motion,
  List<Override> overrides = const [],
}) async {
  final router = GoRouter(routes: $appRoutes);
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        ...fakePortOverrides(
          scanner: scanner,
          permissions: permissions,
          database: database,
          samples: samples,
          lifecycle: lifecycle,
          motion: motion,
        ),
        ...overrides,
      ],
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

/// `pumpAndSettle` that also lets the in-memory database answer: drift does real asynchronous work,
/// which the fake clock of widget tests does not run (e.g. the disclaimer gate reading settings).
Future<void> settleWithDatabase(WidgetTester tester) async {
  for (var i = 0; i < 3; i++) {
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
  }
}

/// Motion readings from the test (none: the phone counts as still).
final class _FakeMotion implements MotionPort {
  _FakeMotion(this._stream);

  final Stream<double>? _stream;

  @override
  Stream<double> get accelerations => _stream ?? const Stream.empty();
}
