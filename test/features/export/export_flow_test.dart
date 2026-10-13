import 'dart:convert';
import 'dart:math';

import 'package:beneathsos_app/core/database/app_database.dart';
import 'package:beneathsos_app/core/sessions/data/drift_session_store.dart';
import 'package:beneathsos_app/core/settings/data/drift_settings_store.dart';
import 'package:beneathsos_app/features/export/presentation/screens/export_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubble_core/rubble_core.dart';

import '../../core/sharing/fake_share.dart';
import '../../helpers/pump_app.dart';

Future<void> _tap(WidgetTester tester, String label) async {
  await tester.ensureVisible(find.text(label).first);
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).first);
  await settleWithDatabase(tester);
}

Future<AppDatabase> _search(WidgetTester tester) async {
  final db = testDatabase();
  addTearDown(db.close);
  await tester.runAsync(() async {
    await DriftSettingsStore(db).write('disclaimer_accepted', '1');
    final store = DriftSessionStore(db, nowMs: () => 1000, random: Random(1));
    final id = await store.create(
      title: 'Atatürk Cad. 12',
      engineProfile: 'voided_pancake@1',
      practice: false,
    );
    await store.append(
      id,
      const TargetSelected(
        target: TargetId('t1'),
        peripheralKey: 'apple-1',
        label: 'Find My',
      ),
    );
  });
  return db;
}

Future<void> _openExport(WidgetTester tester, {bool tr = false}) async {
  await _tap(tester, tr ? 'Aramayı başlat' : 'Start a search');
  await _tap(tester, 'Atatürk Cad. 12');
  await _tap(tester, tr ? 'Bu aramayı dışa aktar' : 'Export this search');
  expect(find.byType(ExportScreen), findsOneWidget);
}

void main() {
  testWidgets(
    'the disclaimer comes first; Export hands two files to the share sheet',
    (tester) async {
      setPhoneSize(tester, 402, 874);
      final db = await _search(tester);
      final share = FakeShare();
      await pumpRouterApp(tester, database: db, share: share);
      await settleWithDatabase(tester);
      await _openExport(tester);
      // Rule 5: the disclaimer on every export.
      expect(find.text('What BeneathSOS does'), findsOneWidget);
      expect(share.shared, isEmpty);
      await _tap(tester, 'Export and share');
      final files = share.shared.single;
      expect(files.map((f) => f.name), [
        'beneathsos-1970-01-01-ataturk-cad-12.json',
        'beneathsos-1970-01-01-ataturk-cad-12-samples.csv',
      ]);
      final json = jsonDecode(files.first.text) as Map<String, Object?>;
      expect(json['disclaimer'], contains('does not replace professional rescue'));
      expect(json['events']! as List, hasLength(2));
      expect(
        find.text('Shared. The files hold this search as recorded.'),
        findsOneWidget,
      );
    },
  );

  testWidgets('a failed export says so and can be tried again', (tester) async {
    setPhoneSize(tester, 402, 874);
    final db = await _search(tester);
    final share = FakeShare()..fail = true;
    await pumpRouterApp(tester, database: db, share: share);
    await settleWithDatabase(tester);
    await _openExport(tester);
    await _tap(tester, 'Export and share');
    expect(find.text('Could not export. Nothing was changed.'), findsOneWidget);
    share.fail = false;
    await _tap(tester, 'Export and share');
    expect(share.shared, hasLength(1));
  });

  testWidgets('Turkish at 200 %: the export button stays readable', (
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
    await _openExport(tester, tr: true);
    expect(tester.takeException(), isNull);
    await expectFullyReadable(tester, find.text('Dışa aktar ve paylaş'));
  });
}
