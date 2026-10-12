import 'dart:math';

import 'package:beneathsos_app/core/database/app_database.dart';
import 'package:beneathsos_app/core/models/ble_sample.dart';
import 'package:beneathsos_app/core/sessions/data/drift_session_store.dart';
import 'package:beneathsos_app/core/sessions/domain/session_store.dart';
import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/core/settings/data/drift_settings_store.dart';
import 'package:beneathsos_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:beneathsos_app/features/preview/presentation/screens/preview_notice_screen.dart';
import 'package:beneathsos_app/features/sites/presentation/screens/new_site_screen.dart';
import 'package:beneathsos_app/features/sites/presentation/screens/site_screen.dart';
import 'package:beneathsos_app/features/sites/presentation/screens/sites_screen.dart';
import 'package:beneathsos_app/features/victim/presentation/screens/victim_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rubble_core/rubble_core.dart';

import '../../helpers/pump_app.dart';

/// The real store, except the operations told to fail (as a full disk or a broken file would).
final class _FailingStore implements SessionStore {
  _FailingStore(
    this.inner, {
    this.failCreate = false,
    this.failAppend = false,
    this.failSummary = false,
  });

  final SessionStore inner;
  final bool failCreate;
  final bool failAppend;
  final bool failSummary;

  static const _disk = FormatException('disk full');

  @override
  Future<SessionId> create({
    required String title,
    required String engineProfile,
    required bool practice,
  }) => failCreate
      ? Future.error(_disk)
      : inner.create(
          title: title,
          engineProfile: engineProfile,
          practice: practice,
        );

  @override
  Future<void> append(SessionId session, SessionEvent event) =>
      failAppend ? Future.error(_disk) : inner.append(session, event);

  @override
  Stream<SessionState> watch(SessionId session) => inner.watch(session);

  @override
  Stream<SessionSummary?> watchLatestOpen() => inner.watchLatestOpen();

  @override
  Stream<SessionSummary?> watchSummary(SessionId session) =>
      failSummary ? Stream.error(_disk) : inner.watchSummary(session);

  @override
  Stream<List<SessionSummary>> watchSearches() => inner.watchSearches();

  @override
  Future<void> addSamples(
    SessionId session,
    PointId? point,
    List<BleSample> samples,
  ) => inner.addSamples(session, point, samples);
}

/// Overrides the store with a [_FailingStore] around the real one on [db].
List<Override> _failing(
  AppDatabase db, {
  bool failCreate = false,
  bool failAppend = false,
  bool failSummary = false,
}) => [
  sessionStoreProvider.overrideWith(
    (ref) => _FailingStore(
      DriftSessionStore(db, nowMs: () => 5000, random: Random(3)),
      failCreate: failCreate,
      failAppend: failAppend,
      failSummary: failSummary,
    ),
  ),
];

Future<void> _settle(WidgetTester tester) => settleWithDatabase(tester);

Future<void> _tap(WidgetTester tester, String label) async {
  await tester.ensureVisible(find.text(label).last);
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await _settle(tester);
}

/// A database where the disclaimer was accepted earlier, optionally with one real search.
Future<(AppDatabase, SessionId?)> _returning(
  WidgetTester tester, {
  String? search,
  bool measured = false,
}) async {
  final db = testDatabase();
  addTearDown(db.close);
  final id = await tester.runAsync(() async {
    await DriftSettingsStore(db).write('disclaimer_accepted', '1');
    if (search == null) return null;
    final store = DriftSessionStore(
      db,
      nowMs: () => DateTime(2026, 10, 12, 14, 5).millisecondsSinceEpoch,
      random: Random(1),
    );
    final id = await store.create(
      title: search,
      engineProfile: 'voided_pancake@1',
      practice: false,
    );
    if (measured) {
      await store.append(
        id,
        RubblePolygonSet(
          RubblePolygon(const [
            SitePoint(Meters.zero, Meters.zero),
            SitePoint(Meters(10), Meters.zero),
            SitePoint(Meters(10), Meters(8)),
          ]),
        ),
      );
      const point = PointId('p1');
      await store.append(
        id,
        const MeasurementPointPlaced(
          point: point,
          at: SitePoint(Meters(2), Meters(2)),
        ),
      );
      await store.append(
        id,
        const MeasurementCompleted(
          point: point,
          duration: Duration(seconds: 15),
          readings: [NoSignal(TargetId('t'))],
        ),
      );
    }
    return id;
  });
  return (db, id);
}

void main() {
  testWidgets('the first search shows the disclaimer once, then the list', (
    tester,
  ) async {
    setPhoneSize(tester, 402, 874);
    await pumpRouterApp(tester);
    await _settle(tester);
    await _tap(tester, 'Start a search');
    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.text('What it does not do'), findsOneWidget);
    await _tap(tester, 'I understand');
    expect(find.byType(SitesScreen), findsOneWidget);
    expect(find.text('No searches yet.'), findsOneWidget);
    await tester.pageBack();
    await _settle(tester);
    await _tap(tester, 'Start a search');
    expect(find.byType(SitesScreen), findsOneWidget);
  });

  testWidgets('"I am trapped" is never behind the disclaimer', (tester) async {
    setPhoneSize(tester, 402, 874);
    await pumpRouterApp(tester);
    await _settle(tester);
    await _tap(tester, 'I am trapped');
    expect(find.byType(VictimScreen), findsOneWidget);
  });

  testWidgets('a new search needs a name, keeps it trimmed and opens', (
    tester,
  ) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _returning(tester);
    await pumpRouterApp(tester, database: db);
    await _settle(tester);
    await _tap(tester, 'Start a search');
    await _tap(tester, 'New search');
    await _tap(tester, 'Create search');
    expect(
      find.text('Enter a name so you can find this search later.'),
      findsOneWidget,
    );
    await tester.enterText(find.byType(TextField), '  Atatürk Cad. 12  ');
    await _tap(tester, 'Create search');
    expect(find.byType(SiteScreen), findsOneWidget);
    expect(find.text('Atatürk Cad. 12'), findsWidgets);
    await tester.pageBack();
    await _settle(tester);
    expect(find.byType(SitesScreen), findsOneWidget);
    expect(find.text('Atatürk Cad. 12'), findsOneWidget);
    final rows = await tester.runAsync(() => db.select(db.sessions).get());
    expect(rows!.map((r) => (r.title, r.practice)), [
      ('Atatürk Cad. 12', false),
    ]);
  });

  testWidgets('a double tap on Create makes one search', (tester) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _returning(tester);
    await pumpRouterApp(tester, database: db);
    await _settle(tester);
    await _tap(tester, 'Start a search');
    await _tap(tester, 'New search');
    await tester.enterText(find.byType(TextField), 'Atatürk Cad. 12');
    await tester.ensureVisible(find.text('Create search'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create search'));
    await tester.tap(find.text('Create search'), warnIfMissed: false);
    await _settle(tester);
    final rows = await tester.runAsync(() => db.select(db.sessions).get());
    expect(rows, hasLength(1));
  });

  testWidgets('the overview shows each step from the recorded events', (
    tester,
  ) async {
    setPhoneSize(tester, 402, 874);
    final (db, id) = await _returning(
      tester,
      search: 'Atatürk Cad. 12',
      measured: true,
    );
    await pumpRouterApp(tester, database: db);
    await _settle(tester);
    await _tap(tester, 'Start a search');
    await _tap(tester, 'Atatürk Cad. 12');
    expect(find.byType(SiteScreen), findsOneWidget);
    expect(find.text('Draw the rubble outline'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);
    expect(find.text('1 point measured'), findsOneWidget);
    expect(find.text('Coming in the next update'), findsNWidgets(2));
    expect(id, isNotNull);
  });

  testWidgets('finishing from the overview marks the search finished', (
    tester,
  ) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _returning(tester, search: 'Atatürk Cad. 12');
    await pumpRouterApp(tester, database: db);
    await _settle(tester);
    await _tap(tester, 'Start a search');
    await _tap(tester, 'Atatürk Cad. 12');
    await _tap(tester, 'Finish this search');
    await _tap(tester, 'Finish');
    expect(
      find.text('This search is finished. Its data stays saved.'),
      findsOneWidget,
    );
    expect(find.text('Finish this search'), findsNothing);
    await tester.pageBack();
    await _settle(tester);
    expect(find.text('Finished'), findsOneWidget);
  });

  testWidgets('an unknown search shows a calm message and a way back', (
    tester,
  ) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _returning(tester);
    await pumpRouterApp(tester, database: db);
    await _settle(tester);
    GoRouter.of(tester.element(find.byType(Scaffold).first))
        .go('/sites/missing');
    await _settle(tester);
    expect(find.text('This search could not be opened.'), findsOneWidget);
    await _tap(tester, 'Back to searches');
    expect(find.byType(SitesScreen), findsOneWidget);
  });

  testWidgets('the home card continues a real search in its overview', (
    tester,
  ) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _returning(tester, search: 'Atatürk Cad. 12');
    await pumpRouterApp(tester, database: db);
    await _settle(tester);
    expect(find.text('Last search'), findsOneWidget);
    await _tap(tester, 'Continue the search');
    expect(find.byType(SiteScreen), findsOneWidget);
  });

  testWidgets('practice with sample data opens the preview journey', (
    tester,
  ) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _returning(tester);
    await pumpRouterApp(tester, database: db);
    await _settle(tester);
    await _tap(tester, 'Start a search');
    await _tap(tester, 'Practice with sample data');
    expect(find.byType(PreviewNoticeScreen), findsOneWidget);
  });

  testWidgets('Turkish at 200 % on a small phone: long names stay readable', (
    tester,
  ) async {
    setPhoneSize(tester, 375, 667);
    const name =
        'Cumhuriyet Mahallesi Atatürk Caddesi No: 12, Antakya / Hatay — B Blok';
    final (db, _) = await _returning(tester, search: name, measured: true);
    await pumpRouterApp(
      tester,
      database: db,
      locale: const Locale('tr'),
      textScale: 2,
    );
    await _settle(tester);
    await _tap(tester, 'Aramayı başlat');
    expect(tester.takeException(), isNull);
    await expectFullyReadable(tester, find.text(name));
    await _tap(tester, name);
    expect(tester.takeException(), isNull);
    await expectFullyReadable(tester, find.text('Enkazın sınırını çizin'));
    await expectFullyReadable(tester, find.text('Bu aramayı bitir'));
    await tester.tap(
      find.byType(BackButton),
    ); // pageBack looks for the English tooltip
    await _settle(tester);
    await _tap(tester, 'Yeni arama');
    expect(tester.takeException(), isNull);
    await expectFullyReadable(tester, find.text('Aramayı oluştur'));
  });

  testWidgets(
    'creating opens the overview without a false "could not be opened"',
    (tester) async {
      setPhoneSize(tester, 402, 874);
      final (db, _) = await _returning(tester);
      await pumpRouterApp(tester, database: db);
      await _settle(tester);
      await _tap(tester, 'Start a search');
      await _tap(tester, 'New search');
      await tester.enterText(find.byType(TextField), 'Atatürk Cad. 12');
      await tester.tap(find.text('Create search'));
      for (var frame = 0; frame < 30; frame++) {
        await tester.runAsync(() => Future<void>.delayed(Duration.zero));
        await tester.pump(const Duration(milliseconds: 16));
        expect(
          find.text('This search could not be opened.'),
          findsNothing,
          reason: 'frame $frame',
        );
      }
      await tester.pumpAndSettle();
      expect(find.byType(SiteScreen), findsOneWidget);
    },
  );

  testWidgets('a search that cannot be saved says so', (tester) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _returning(tester);
    await pumpRouterApp(
      tester,
      database: db,
      overrides: _failing(db, failCreate: true),
    );
    await _settle(tester);
    await _tap(tester, 'Start a search');
    await _tap(tester, 'New search');
    await tester.enterText(find.byType(TextField), 'Atatürk Cad. 12');
    await _tap(tester, 'Create search');
    expect(find.byType(NewSiteScreen), findsOneWidget);
    expect(
      find.text('The search could not be saved. Try again in a moment.'),
      findsOneWidget,
    );
  });

  testWidgets('a search that cannot be finished says so', (tester) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _returning(tester, search: 'Atatürk Cad. 12');
    await pumpRouterApp(
      tester,
      database: db,
      overrides: _failing(db, failAppend: true),
    );
    await _settle(tester);
    await _tap(tester, 'Start a search');
    await _tap(tester, 'Atatürk Cad. 12');
    await _tap(tester, 'Finish this search');
    await _tap(tester, 'Finish');
    expect(
      find.text('The search could not be finished. Try again in a moment.'),
      findsOneWidget,
    );
    expect(find.text('Finish this search'), findsOneWidget);
  });

  testWidgets('an overview that cannot be loaded gives a way back', (
    tester,
  ) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _returning(tester, search: 'Atatürk Cad. 12');
    await pumpRouterApp(
      tester,
      database: db,
      overrides: _failing(db, failSummary: true),
    );
    await _settle(tester);
    await _tap(tester, 'Start a search');
    await _tap(tester, 'Atatürk Cad. 12');
    expect(find.text('This search could not be opened.'), findsOneWidget);
    await _tap(tester, 'Back to searches');
    expect(find.byType(SitesScreen), findsOneWidget);
  });

  testWidgets(
    'a returning rescuer goes straight to the list, even right after launch',
    (tester) async {
      setPhoneSize(tester, 402, 874);
      final (db, _) = await _returning(tester);
      await pumpRouterApp(tester, database: db);
      await _tap(tester, 'Start a search');
      expect(find.byType(OnboardingScreen), findsNothing);
      expect(find.byType(SitesScreen), findsOneWidget);
    },
  );

  testWidgets(
    'a link to a new search on first use: disclaimer, then the form',
    (tester) async {
      setPhoneSize(tester, 402, 874);
      await pumpRouterApp(tester);
      await _settle(tester);
      GoRouter.of(tester.element(find.byType(Scaffold).first)).go('/sites/new');
      await _settle(tester);
      expect(find.byType(OnboardingScreen), findsOneWidget);
      await _tap(tester, 'I understand');
      expect(find.byType(NewSiteScreen), findsOneWidget);
    },
  );
}
