import 'dart:convert';
import 'dart:math';

import 'package:beneathsos_app/core/database/app_database.dart';
import 'package:beneathsos_app/core/sessions/data/drift_session_store.dart';
import 'package:beneathsos_app/core/settings/data/drift_settings_store.dart';
import 'package:beneathsos_app/features/site_depth/presentation/screens/depth_screen.dart';
import 'package:beneathsos_app/features/sites/presentation/screens/site_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

Future<void> _tap(WidgetTester tester, String label) async {
  await tester.ensureVisible(find.text(label).last);
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await settleWithDatabase(tester);
}

Future<AppDatabase> _search(WidgetTester tester) async {
  final db = testDatabase();
  addTearDown(db.close);
  await tester.runAsync(() async {
    await DriftSettingsStore(db).write('disclaimer_accepted', '1');
    await DriftSessionStore(db, nowMs: () => 1000, random: Random(1)).create(
      title: 'Atatürk Cad. 12',
      engineProfile: 'voided_pancake@1',
      practice: false,
    );
  });
  return db;
}

Future<void> _openDepth(WidgetTester tester, {bool tr = false}) async {
  await _tap(tester, tr ? 'Aramayı başlat' : 'Start a search');
  await _tap(tester, 'Atatürk Cad. 12');
  await _tap(
    tester,
    tr ? 'Enkaz yüksekliği ve seviye' : 'Rubble height and level',
  );
  expect(find.byType(DepthScreen), findsOneWidget);
}

void main() {
  testWidgets(
    'the rescuer gives the rubble height and the likely level; the overview shows it',
    (tester) async {
      setPhoneSize(tester, 402, 874);
      final db = await _search(tester);
      await pumpRouterApp(tester, database: db);
      await settleWithDatabase(tester);
      await _openDepth(tester);
      await _tap(tester, '2 floors ≈ 6 m');
      await _tap(tester, 'Ground floor (bottom)');
      await _tap(tester, 'Save');
      expect(find.byType(SiteScreen), findsOneWidget);
      expect(find.text('6.0 m · Ground floor (bottom)'), findsOneWidget);
      final last = (await tester.runAsync(() => db.select(db.events).get()))!
          .last;
      expect(last.type, 'RubbleDepthSet');
      expect(jsonDecode(last.payload), {'heightM': 6.0, 'level': 'bottom'});
    },
  );

  testWidgets('the height must be a number between 0.5 and 100 m', (
    tester,
  ) async {
    setPhoneSize(tester, 402, 874);
    final db = await _search(tester);
    await pumpRouterApp(tester, database: db);
    await settleWithDatabase(tester);
    await _openDepth(tester);
    await _tap(tester, 'Save');
    expect(
      find.text('Enter the height in metres, for example 6.'),
      findsOneWidget,
    );
    await tester.enterText(find.byType(TextField), '300');
    await _tap(tester, 'Save');
    expect(find.text('Use a height between 0.5 and 100 m.'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '4,5');
    await _tap(tester, "Don't know");
    await _tap(tester, 'Save');
    expect(find.text("4.5 m · Don't know"), findsOneWidget);
  });

  testWidgets('Turkish at 200 % on a small phone: the form stays readable', (
    tester,
  ) async {
    setPhoneSize(tester, 375, 667);
    final db = await _search(tester);
    await pumpRouterApp(
      tester,
      database: db,
      locale: const Locale('tr'),
      textScale: 2,
    );
    await settleWithDatabase(tester);
    await _openDepth(tester, tr: true);
    expect(tester.takeException(), isNull);
    await expectFullyReadable(tester, find.text('Kaydet'));
  });
}
