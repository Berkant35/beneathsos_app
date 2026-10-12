import 'dart:math';

import 'package:beneathsos_app/core/database/app_database.dart';
import 'package:beneathsos_app/core/sessions/data/drift_session_store.dart';
import 'package:beneathsos_app/core/settings/data/drift_settings_store.dart';
import 'package:beneathsos_app/features/site_drawing/presentation/screens/draw_outline_screen.dart';
import 'package:beneathsos_app/features/site_drawing/presentation/screens/scale_screen.dart';
import 'package:beneathsos_app/features/sites/presentation/screens/site_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubble_canvas/rubble_canvas.dart';
import 'package:rubble_core/rubble_core.dart';

import '../../helpers/pump_app.dart';

Future<void> _tap(WidgetTester tester, String label) async {
  await tester.ensureVisible(find.text(label).last);
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await settleWithDatabase(tester);
}

/// A returning rescuer with one open search, optionally already drawn.
Future<(AppDatabase, SessionId)> _search(
  WidgetTester tester, {
  RubblePolygon? outline,
}) async {
  final db = testDatabase();
  addTearDown(db.close);
  final id = await tester.runAsync(() async {
    await DriftSettingsStore(db).write('disclaimer_accepted', '1');
    final store = DriftSessionStore(db, nowMs: () => 1000, random: Random(1));
    final id = await store.create(
      title: 'Atatürk Cad. 12',
      engineProfile: 'voided_pancake@1',
      practice: false,
    );
    if (outline != null) await store.append(id, RubblePolygonSet(outline));
    return id;
  });
  return (db, id!);
}

Future<SessionState> _stored(
  WidgetTester tester,
  AppDatabase db,
  SessionId id,
) async => (await tester.runAsync(
  () => DriftSessionStore(
    db,
    nowMs: () => 1000,
    random: Random(9),
  ).watch(id).first,
))!;

/// Taps the canvas at [site] metres (the first view of an empty outline spans 30 m, origin in the
/// middle).
Future<void> _tapSite(WidgetTester tester, double x, double y) async {
  final rect = tester.getRect(find.byType(OutlineEditor));
  final pxPerMetre = rect.shortestSide / 30;
  await tester.tapAt(rect.center + Offset(x * pxPerMetre, -y * pxPerMetre));
  await tester.pumpAndSettle();
}

Future<void> _openDrawing(WidgetTester tester) async {
  await _tap(tester, 'Start a search');
  await _tap(tester, 'Atatürk Cad. 12');
  await _tap(tester, 'Draw the rubble outline');
  expect(find.byType(DrawOutlineScreen), findsOneWidget);
}

void main() {
  testWidgets(
    'three taps draw an outline; it is stored and the overview shows its area',
    (tester) async {
      setPhoneSize(tester, 402, 874);
      final (db, id) = await _search(tester);
      await pumpRouterApp(tester, database: db);
      await settleWithDatabase(tester);
      await _openDrawing(tester);
      expect(find.text('Tap at least 3 corners.'), findsWidgets);
      await _tapSite(tester, -5, -4);
      await _tapSite(tester, 5, -4);
      await _tapSite(tester, 5, 4);
      expect(find.textContaining('3 corners · perimeter'), findsWidgets);
      await _tap(tester, 'Outline done');
      expect(find.byType(ScaleScreen), findsOneWidget);
      await _tap(tester, 'Skip');
      expect(find.byType(SiteScreen), findsOneWidget);
      expect(find.text('Done · 40 m²'), findsOneWidget);
      final stored = await _stored(tester, db, id);
      expect(stored.outline!.corners, const [
        SitePoint(Meters(-5), Meters(-4)),
        SitePoint(Meters(5), Meters(-4)),
        SitePoint(Meters(5), Meters(4)),
      ]);
    },
  );

  testWidgets('Outline done stays off until there is a valid outline', (
    tester,
  ) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _search(tester);
    await pumpRouterApp(tester, database: db);
    await settleWithDatabase(tester);
    await _openDrawing(tester);
    await _tapSite(tester, 0, 0);
    await _tapSite(tester, 6, 0);
    final done = tester.widget<FilledButton>(
      find.ancestor(
        of: find.text('Outline done'),
        matching: find.byWidgetPredicate((w) => w is FilledButton),
      ),
    );
    expect(done.onPressed, isNull);
    await _tap(tester, 'Undo');
    expect(find.text('Tap at least 3 corners.'), findsWidgets);
  });

  testWidgets('a real length sets the scale with how it was measured', (
    tester,
  ) async {
    setPhoneSize(tester, 402, 874);
    final outline = RubblePolygon(const [
      SitePoint(Meters.zero, Meters.zero),
      SitePoint(Meters(16), Meters.zero),
      SitePoint(Meters(16), Meters(4)),
      SitePoint(Meters.zero, Meters(4)),
    ]);
    final (db, id) = await _search(tester, outline: outline);
    await pumpRouterApp(tester, database: db);
    await settleWithDatabase(tester);
    await _openDrawing(tester);
    await _tap(
      tester,
      'Outline done',
    ); // unchanged: stored once, opens the scale step
    expect(find.byType(ScaleScreen), findsOneWidget);
    expect(find.text('Now shown as 16.0 m'), findsWidgets);
    await _tap(tester, 'Save the size');
    expect(find.text('Enter a number, for example 18.5.'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '0.2');
    await _tap(tester, 'Save the size');
    expect(find.text('Use a length between 0.5 and 500 m.'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '20');
    await _tap(tester, 'Paced steps');
    await _tap(tester, 'Save the size');
    expect(find.byType(SiteScreen), findsOneWidget);
    final stored = await _stored(tester, db, id);
    expect(stored.scale, 1.25);
    // 16 × 4 m drawn, × 1.25² = 100 m².
    expect(find.text('Done · 100 m²'), findsOneWidget);
    final events = await tester.runAsync(() => db.select(db.events).get());
    expect(events!.map((e) => e.type), [
      'SiteCreated',
      'RubblePolygonSet',
      'ScaleSet',
    ]);
    expect(events.last.payload, contains('"steps"'));
  });

  testWidgets('reopening the drawing shows the stored outline', (tester) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _search(
      tester,
      outline: RubblePolygon(const [
        SitePoint(Meters.zero, Meters.zero),
        SitePoint(Meters(10), Meters.zero),
        SitePoint(Meters(10), Meters(10)),
        SitePoint(Meters.zero, Meters(10)),
      ]),
    );
    await pumpRouterApp(tester, database: db);
    await settleWithDatabase(tester);
    await _openDrawing(tester);
    expect(
      find.textContaining('4 corners · perimeter 40.0 m · area 100 m²'),
      findsWidgets,
    );
  });

  testWidgets('clearing a drawn outline asks first', (tester) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _search(
      tester,
      outline: RubblePolygon(const [
        SitePoint(Meters.zero, Meters.zero),
        SitePoint(Meters(10), Meters.zero),
        SitePoint(Meters(10), Meters(10)),
      ]),
    );
    await pumpRouterApp(tester, database: db);
    await settleWithDatabase(tester);
    await _openDrawing(tester);
    await _tap(tester, 'Clear');
    expect(find.text('Clear the outline?'), findsOneWidget);
    await _tap(tester, 'Keep it');
    expect(find.textContaining('3 corners'), findsWidgets);
    await _tap(tester, 'Clear');
    await tester.tap(find.text('Clear').last);
    await tester.pumpAndSettle();
    expect(find.text('Tap at least 3 corners.'), findsWidgets);
  });

  testWidgets('a finished search cannot be drawn', (tester) async {
    setPhoneSize(tester, 402, 874);
    final (db, id) = await _search(tester);
    await tester.runAsync(
      () => DriftSessionStore(
        db,
        nowMs: () => 2000,
        random: Random(2),
      ).append(id, const SessionClosed()),
    );
    await pumpRouterApp(tester, database: db);
    await settleWithDatabase(tester);
    await _tap(tester, 'Start a search');
    await _tap(tester, 'Atatürk Cad. 12');
    expect(
      find.text('Not done'),
      findsNWidgets(3),
    ); // outline, surface scan, target
    await _tap(tester, 'Draw the rubble outline');
    expect(find.byType(DrawOutlineScreen), findsNothing);
  });

  testWidgets('Turkish at 200 % on a small phone: controls stay readable', (
    tester,
  ) async {
    setPhoneSize(tester, 375, 667);
    final (db, _) = await _search(
      tester,
      outline: RubblePolygon(const [
        SitePoint(Meters.zero, Meters.zero),
        SitePoint(Meters(18.2), Meters.zero),
        SitePoint(Meters(18.2), Meters(12.4)),
        SitePoint(Meters.zero, Meters(12.4)),
      ]),
    );
    await pumpRouterApp(
      tester,
      database: db,
      locale: const Locale('tr'),
      textScale: 2,
    );
    await settleWithDatabase(tester);
    await _tap(tester, 'Aramayı başlat');
    await _tap(tester, 'Atatürk Cad. 12');
    await _tap(tester, 'Enkazın sınırını çizin');
    expect(tester.takeException(), isNull);
    expect(find.byType(OutlineEditor), findsOneWidget);
    await expectFullyReadable(tester, find.text('Çizim tamam'));
    await _tap(tester, 'Çizim tamam');
    expect(tester.takeException(), isNull);
    await expectFullyReadable(tester, find.text('Boyutu kaydet'));
    await expectFullyReadable(tester, find.text('Adımlayarak'));
  });

  testWidgets('Back with unsaved corners asks before the drawing is lost', (
    tester,
  ) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _search(tester);
    await pumpRouterApp(tester, database: db);
    await settleWithDatabase(tester);
    await _openDrawing(tester);
    await _tapSite(tester, 0, 0);
    await tester.tap(find.byType(BackButton));
    await settleWithDatabase(tester);
    expect(find.text('Leave without saving?'), findsOneWidget);
    await _tap(tester, 'Keep drawing');
    expect(find.byType(DrawOutlineScreen), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await settleWithDatabase(tester);
    await _tap(tester, 'Leave');
    expect(find.byType(SiteScreen), findsOneWidget);
  });

  testWidgets('Back without changes leaves at once', (tester) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _search(tester);
    await pumpRouterApp(tester, database: db);
    await settleWithDatabase(tester);
    await _openDrawing(tester);
    await tester.tap(find.byType(BackButton));
    await settleWithDatabase(tester);
    expect(find.byType(SiteScreen), findsOneWidget);
  });

  testWidgets('a size that changes every length a lot asks first', (
    tester,
  ) async {
    setPhoneSize(tester, 402, 874);
    final (db, id) = await _search(
      tester,
      outline: RubblePolygon(const [
        SitePoint(Meters.zero, Meters.zero),
        SitePoint(Meters(16), Meters.zero),
        SitePoint(Meters(16), Meters(4)),
        SitePoint(Meters.zero, Meters(4)),
      ]),
    );
    await pumpRouterApp(tester, database: db);
    await settleWithDatabase(tester);
    await _openDrawing(tester);
    await _tap(tester, 'Outline done');
    await tester.enterText(find.byType(TextField), '180');
    await _tap(tester, 'Save the size');
    expect(find.text('Is this right?'), findsOneWidget);
    await _tap(tester, 'Correct it');
    expect(find.byType(ScaleScreen), findsOneWidget);
    expect((await _stored(tester, db, id)).scale, 1);
    await _tap(tester, 'Save the size');
    await _tap(tester, 'Save anyway');
    expect(find.byType(SiteScreen), findsOneWidget);
    expect((await _stored(tester, db, id)).scale, 11.25);
  });
}
