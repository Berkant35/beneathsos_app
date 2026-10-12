import 'dart:math';

import 'package:beneathsos_app/core/database/app_database.dart';
import 'package:beneathsos_app/core/sessions/data/drift_session_store.dart';
import 'package:beneathsos_app/core/settings/data/drift_settings_store.dart';
import 'package:beneathsos_app/features/measurement/presentation/screens/measure_screen.dart';
import 'package:beneathsos_app/features/probability_map/presentation/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubble_canvas/rubble_canvas.dart';
import 'package:rubble_core/rubble_core.dart';

import '../../helpers/pump_app.dart';

SitePoint p(double x, double y) => SitePoint(Meters(x), Meters(y));

const _phone = TargetId('t1');
const _watch = TargetId('t2');

Future<void> _tap(WidgetTester tester, String label) async {
  await tester.ensureVisible(find.text(label).first);
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).first);
  await settleWithDatabase(tester);
}

/// A 10 × 10 m search with two targets; [measured] adds three points: the phone heard at two of
/// them, the watch at one.
Future<AppDatabase> _search(WidgetTester tester, {bool measured = true}) async {
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
    Future<void> add(SessionEvent event) => store.append(id, event);
    await add(
      RubblePolygonSet(RubblePolygon([p(0, 0), p(10, 0), p(10, 10), p(0, 10)])),
    );
    await add(
      const TargetSelected(
        target: _phone,
        peripheralKey: 'apple-1',
        label: 'Apple · Find My',
      ),
    );
    await add(
      const TargetSelected(
        target: _watch,
        peripheralKey: 'watch-1',
        label: 'Watch',
      ),
    );
    if (!measured) return;
    Future<void> point(String id, SitePoint at, List<TargetReading> r) async {
      await add(MeasurementPointPlaced(point: PointId(id), at: at));
      await add(
        MeasurementCompleted(
          point: PointId(id),
          duration: const Duration(seconds: 15),
          readings: r,
        ),
      );
    }

    await point('a', p(-1, -1), [
      SignalHeard(_phone, median: const Dbm(-80), samples: 20),
      const NoSignal(_watch),
    ]);
    await point('b', p(11, -1), [
      const NoSignal(_phone),
      SignalHeard(_watch, median: const Dbm(-90), samples: 20),
    ]);
    await point('c', p(11, 11), [
      SignalHeard(_phone, median: const Dbm(-85), samples: 20),
      const NoSignal(_watch),
    ]);
  });
  return db;
}

Future<void> _openMap(WidgetTester tester, {Locale? tr}) async {
  await _tap(tester, tr == null ? 'Start a search' : 'Aramayı başlat');
  await _tap(tester, 'Atatürk Cad. 12');
  await _tap(
    tester,
    tr == null ? 'Open the probability map' : 'Olasılık haritasını aç',
  );
  // The engine's result arrives through a future.
  await settleWithDatabase(tester);
}

String _areasText(WidgetTester tester) => tester
    .widgetList<Text>(find.textContaining('Most likely area'))
    .first
    .data!;

void main() {
  testWidgets(
    'the map shows the 50 % / 90 % areas, never a spot, and asks for more points',
    (tester) async {
      setPhoneSize(tester, 402, 874);
      final db = await _search(tester);
      await pumpRouterApp(tester, database: db);
      await settleWithDatabase(tester);
      await _openMap(tester);
      expect(find.byType(MapScreen), findsOneWidget);
      expect(
        _areasText(tester),
        matches(RegExp(r'^Most likely area: .+ m² \(50 %\) · .+ m² \(90 %\)$')),
      );
      expect(
        find.text(
          'This is an area where the phone most likely is — never an exact spot.',
        ),
        findsOneWidget,
      );
      // Heard at 2 points only.
      expect(find.textContaining('Low information'), findsOneWidget);
      final map = tester.widget<SiteMap>(find.byType(SiteMap));
      final heat = map.heat!;
      final core = [
        for (var i = 0; i < heat.length; i++)
          if (heat.regionOf(i) == HeatRegion.likely50) i,
      ];
      expect(core.length, greaterThan(1), reason: 'a region, not a pin');
      expect(
        map.points.where((m) => m.kind == MapPointKind.suggested),
        hasLength(1),
      );
      expect(
        map.points.where((m) => m.kind == MapPointKind.heard),
        hasLength(2),
      );
    },
  );

  testWidgets('each target has its own map', (tester) async {
    setPhoneSize(tester, 402, 874);
    final db = await _search(tester);
    await pumpRouterApp(tester, database: db);
    await settleWithDatabase(tester);
    await _openMap(tester);
    final phone = _areasText(tester);
    expect(find.byType(ChoiceChip), findsNWidgets(2));
    await tester.tap(find.widgetWithText(ChoiceChip, 'Watch'));
    await settleWithDatabase(tester);
    expect(_areasText(tester), isNot(phone));
    final map = tester.widget<SiteMap>(find.byType(SiteMap));
    expect(map.points.where((m) => m.kind == MapPointKind.heard), hasLength(1));
  });

  testWidgets('Measure next point opens measuring', (tester) async {
    setPhoneSize(tester, 402, 874);
    final db = await _search(tester);
    await pumpRouterApp(tester, database: db);
    await settleWithDatabase(tester);
    await _openMap(tester);
    await _tap(tester, 'Measure next point');
    expect(find.byType(MeasureScreen), findsOneWidget);
  });

  testWidgets('the overview offers the map only once a point is measured', (
    tester,
  ) async {
    setPhoneSize(tester, 402, 874);
    final db = await _search(tester, measured: false);
    await pumpRouterApp(tester, database: db);
    await settleWithDatabase(tester);
    await _tap(tester, 'Start a search');
    await _tap(tester, 'Atatürk Cad. 12');
    expect(find.text('Open the probability map'), findsNothing);
  });

  testWidgets('a failing engine says so and keeps everything', (tester) async {
    setPhoneSize(tester, 402, 874);
    final db = await _search(tester);
    await pumpRouterApp(
      tester,
      database: db,
      engine: (request) async => throw StateError('engine'),
    );
    await settleWithDatabase(tester);
    await _openMap(tester);
    expect(
      find.text('The map could not be calculated. Nothing was deleted.'),
      findsOneWidget,
    );
  });

  testWidgets('Turkish at 200 % on a small phone: the panel stays readable', (
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
    await _openMap(tester, tr: const Locale('tr'));
    expect(tester.takeException(), isNull);
    expect(find.byType(SiteMap), findsOneWidget);
    await expectFullyReadable(tester, find.text('Sonraki noktayı ölç'));
  });
}
