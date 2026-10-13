import 'dart:convert';
import 'dart:math';

import 'package:beneathsos_app/core/database/app_database.dart';
import 'package:beneathsos_app/core/sessions/data/drift_session_store.dart';
import 'package:beneathsos_app/core/settings/data/drift_settings_store.dart';
import 'package:beneathsos_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

Future<void> _tap(WidgetTester tester, String label) async {
  await tester.ensureVisible(find.text(label).last);
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await settleWithDatabase(tester);
}

Future<AppDatabase> _db(WidgetTester tester, {bool searches = false}) async {
  final db = testDatabase();
  addTearDown(db.close);
  await tester.runAsync(() async {
    await DriftSettingsStore(db).write('disclaimer_accepted', '1');
    if (!searches) return;
    final store = DriftSessionStore(db, nowMs: () => 1000, random: Random(1));
    await store.create(
      title: 'Atatürk Cad. 12',
      engineProfile: 'voided_pancake@1',
      practice: false,
    );
    await store.create(
      title: 'Practice',
      engineProfile: 'voided_pancake@1',
      practice: true,
    );
  });
  return db;
}

Future<void> _openSettings(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Settings'));
  await settleWithDatabase(tester);
  expect(find.byType(SettingsScreen), findsOneWidget);
}

void main() {
  testWidgets('the language can be chosen: Türkçe at once, everywhere', (
    tester,
  ) async {
    setPhoneSize(tester, 402, 874);
    final db = await _db(tester);
    await pumpRouterApp(tester, database: db);
    await settleWithDatabase(tester);
    await _openSettings(tester);
    await _tap(tester, 'Türkçe');
    expect(find.text('Ayarlar'), findsOneWidget);
    await _tap(tester, 'English');
    expect(find.text('Settings'), findsWidgets);
  });

  testWidgets('a new search uses the default rubble type chosen in Settings', (
    tester,
  ) async {
    setPhoneSize(tester, 402, 874);
    final db = await _db(tester);
    await pumpRouterApp(tester, database: db);
    await settleWithDatabase(tester);
    await _openSettings(tester);
    await _tap(tester, 'Dense');
    await tester.tap(find.byType(BackButton));
    await settleWithDatabase(tester);
    await _tap(tester, 'Start a search');
    await _tap(tester, 'New search');
    await tester.enterText(find.byType(TextField), 'İnönü Sok. 3');
    await _tap(tester, 'Create search');
    final first = (await tester.runAsync(() => db.select(db.events).get()))!
        .first;
    final payload = jsonDecode(first.payload) as Map<String, Object?>;
    expect(payload['engineProfile'], 'dense@1');
  });

  testWidgets('search settings are kept: height, measuring time, circles', (
    tester,
  ) async {
    setPhoneSize(tester, 402, 874);
    final db = await _db(tester);
    await pumpRouterApp(tester, database: db);
    await settleWithDatabase(tester);
    await _openSettings(tester);
    await _tap(tester, '9 m');
    await _tap(tester, '30 s');
    await _tap(tester, 'Signal circles (rough guide)');
    final stored = await tester.runAsync(() => db.select(db.settings).get());
    final values = {for (final r in stored!) r.key: r.value};
    expect(values['default_rubble_height'], '9.0');
    expect(values['measure_seconds'], '30');
    expect(values['signal_circles'], 'false');
  });

  testWidgets(
    'practice searches or all searches can be deleted, after asking',
    (tester) async {
      setPhoneSize(tester, 402, 874);
      final db = await _db(tester, searches: true);
      await pumpRouterApp(tester, database: db);
      await settleWithDatabase(tester);
      await _openSettings(tester);
      await _tap(tester, 'Delete practice searches');
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Delete'),
        ),
      );
      await settleWithDatabase(tester);
      var sessions = await tester.runAsync(() => db.select(db.sessions).get());
      expect(sessions!.map((s) => s.title), ['Atatürk Cad. 12']);
      await _tap(tester, 'Delete all searches');
      await _tap(tester, 'Keep them');
      sessions = await tester.runAsync(() => db.select(db.sessions).get());
      expect(sessions, hasLength(1));
      await _tap(tester, 'Delete all searches');
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Delete'),
        ),
      );
      await settleWithDatabase(tester);
      sessions = await tester.runAsync(() => db.select(db.sessions).get());
      expect(sessions, isEmpty);
    },
  );

  testWidgets('about: version, the disclaimer, privacy and licences', (
    tester,
  ) async {
    setPhoneSize(tester, 402, 874);
    final db = await _db(tester);
    await pumpRouterApp(tester, database: db);
    await settleWithDatabase(tester);
    await _openSettings(tester);
    expect(find.text('Version 1.0.0 (64)'), findsOneWidget);
    await _tap(tester, 'Read the disclaimer again');
    expect(find.text('What BeneathSOS does'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await settleWithDatabase(tester);
    await _tap(tester, 'Privacy');
    expect(find.textContaining('collects nothing'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await settleWithDatabase(tester);
    await _tap(tester, 'Open-source licences');
    expect(find.byType(LicensePage), findsOneWidget);
  });

  testWidgets('Turkish at 200 % on a small phone: Settings stay readable', (
    tester,
  ) async {
    setPhoneSize(tester, 375, 667);
    final db = await _db(tester);
    await pumpRouterApp(
      tester,
      database: db,
      locale: const Locale('tr'),
      textScale: 2,
    );
    await settleWithDatabase(tester);
    await tester.tap(find.byTooltip('Ayarlar'));
    await settleWithDatabase(tester);
    expect(tester.takeException(), isNull);
    await expectFullyReadable(tester, find.text('Tüm aramaları sil'));
  });
}
