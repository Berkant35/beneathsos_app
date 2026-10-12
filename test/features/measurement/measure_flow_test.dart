import 'dart:async';
import 'dart:math';

import 'package:beneathsos_app/core/database/app_database.dart';
import 'package:beneathsos_app/core/models/ble_sample.dart';
import 'package:beneathsos_app/core/sessions/data/drift_session_store.dart';
import 'package:beneathsos_app/core/settings/data/drift_settings_store.dart';
import 'package:beneathsos_app/features/measurement/presentation/screens/measure_screen.dart';
import 'package:beneathsos_app/features/sites/presentation/screens/site_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubble_canvas/rubble_canvas.dart';
import 'package:rubble_core/rubble_core.dart';

import '../../helpers/pump_app.dart';

var _n = 0;

List<BleSample> _heard(String key, int rssi, {int count = 3}) => [
  for (var i = 0; i < count; i++)
    BleSample(
      key: key,
      rssi: rssi,
      serviceUuids: const [],
      monotonicNanos: _n,
      // The tracker forgets by the wall clock.
      wallClockMillis: DateTime.now().millisecondsSinceEpoch + _n++,
    ),
];

Future<void> _tap(WidgetTester tester, String label) async {
  await tester.ensureVisible(find.text(label).first);
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).first);
  await settleWithDatabase(tester);
}

/// A search with a 10 × 10 m outline and, unless [target] is false, a tracked phone `apple-1`.
Future<(AppDatabase, SessionId)> _search(
  WidgetTester tester, {
  bool outline = true,
  bool target = true,
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
    if (outline) {
      await store.append(
        id,
        RubblePolygonSet(
          RubblePolygon(const [
            SitePoint(Meters.zero, Meters.zero),
            SitePoint(Meters(10), Meters.zero),
            SitePoint(Meters(10), Meters(10)),
            SitePoint(Meters.zero, Meters(10)),
          ]),
        ),
      );
    }
    if (target) {
      await store.append(
        id,
        const TargetSelected(
          target: TargetId('t1'),
          peripheralKey: 'apple-1',
          label: 'Apple · Find My',
        ),
      );
    }
    return id;
  });
  return (db, id!);
}

Future<List<String>> _types(WidgetTester tester, AppDatabase db) async => [
  for (final e in (await tester.runAsync(() => db.select(db.events).get()))!)
    e.type,
];

/// Opens measuring and taps the middle of the map (the middle of the outline: 5, 5 m).
Future<void> _placePoint(WidgetTester tester) async {
  await tester.tap(find.byType(SiteMap));
  await tester.runAsync(() => Future<void>.delayed(Duration.zero));
  for (var i = 0; i < 3; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

Future<void> _seconds(
  WidgetTester tester,
  int seconds, {
  VoidCallback? each,
}) async {
  for (var s = 0; s < seconds; s++) {
    each?.call();
    await tester.pump(const Duration(seconds: 1));
  }
  await settleWithDatabase(tester);
}

Future<StreamController<List<BleSample>>> _open(
  WidgetTester tester,
  AppDatabase db, {
  Stream<double>? motion,
}) async {
  final samples = StreamController<List<BleSample>>.broadcast();
  addTearDown(() => unawaited(samples.close()));
  await pumpRouterApp(
    tester,
    database: db,
    samples: samples.stream,
    motion: motion,
  );
  await settleWithDatabase(tester);
  await _tap(tester, 'Start a search');
  await _tap(tester, 'Atatürk Cad. 12');
  await _tap(tester, 'Measure at points around the rubble');
  expect(find.byType(MeasureScreen), findsOneWidget);
  return samples;
}

void main() {
  setUp(() => _n = 0);

  testWidgets(
    'a point where the phone is heard stores its median and the raw readings',
    (tester) async {
      setPhoneSize(tester, 402, 874);
      final (db, _) = await _search(tester);
      // ignore: close_sinks, closed by _open's tear-down
      final samples = await _open(tester, db);
      await _placePoint(tester);
      expect(find.text('Hold the phone still at this point.'), findsOneWidget);
      await _seconds(
        tester,
        16,
        each: () => samples.add(_heard('apple-1', -80)),
      );
      expect(find.text('Point saved: signal heard (−80 dBm).'), findsOneWidget);
      expect(await _types(tester, db), [
        'SiteCreated',
        'RubblePolygonSet',
        'TargetSelected',
        'MeasurementPointPlaced',
        'MeasurementCompleted',
      ]);
      final rows = await tester.runAsync(() => db.select(db.rssiSamples).get());
      expect(rows, isNotEmpty);
      final completed = (await tester.runAsync(
        () => db.select(db.events).get(),
      ))!.last;
      expect(completed.payload, contains('"medianDbm":-80'));
    },
  );

  testWidgets(
    'a point where nothing is heard is stored as no signal (rule 3)',
    (tester) async {
      setPhoneSize(tester, 402, 874);
      final (db, _) = await _search(tester);
      await _open(tester, db);
      await _placePoint(tester);
      await _seconds(tester, 16);
      expect(
        find.text('Point saved: not heard — that is information too.'),
        findsOneWidget,
      );
      final completed = (await tester.runAsync(
        () => db.select(db.events).get(),
      ))!.last;
      expect(completed.type, 'MeasurementCompleted');
      expect(completed.payload, contains('"kind":"none"'));
    },
  );

  testWidgets('moving pauses the countdown and says why', (tester) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _search(tester);
    final motion = StreamController<double>.broadcast();
    addTearDown(motion.close);
    await _open(tester, db, motion: motion.stream);
    await _placePoint(tester);
    await _seconds(tester, 20, each: () => motion.add(2));
    expect(
      find.text('Moving — the count waits until the phone is still.'),
      findsOneWidget,
    );
    expect(await _types(tester, db), isNot(contains('MeasurementCompleted')));
    await _seconds(tester, 18);
    expect(await _types(tester, db), contains('MeasurementCompleted'));
  });

  testWidgets('Discard throws the point away with the reason', (tester) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _search(tester);
    await _open(tester, db);
    await _placePoint(tester);
    await _tap(tester, 'Discard this point');
    final events = (await tester.runAsync(() => db.select(db.events).get()))!;
    expect(events.last.type, 'MeasurementDiscarded');
    expect(events.last.payload, contains('userDiscarded'));
  });

  testWidgets('leaving while measuring discards the point as interrupted', (
    tester,
  ) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _search(tester);
    await _open(tester, db);
    await _placePoint(tester);
    await tester.tap(find.byType(BackButton));
    await settleWithDatabase(tester);
    expect(find.byType(SiteScreen), findsOneWidget);
    final events = (await tester.runAsync(() => db.select(db.events).get()))!;
    expect(events.last.type, 'MeasurementDiscarded');
    expect(events.last.payload, contains('interrupted'));
  });

  testWidgets('measuring needs an outline first', (tester) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _search(tester, outline: false);
    await _open(tester, db);
    expect(find.text('Draw the rubble outline first.'), findsOneWidget);
  });

  testWidgets('Turkish at 200 % on a small phone: the panel stays readable', (
    tester,
  ) async {
    setPhoneSize(tester, 375, 667);
    final (db, _) = await _search(tester);
    final samples = StreamController<List<BleSample>>.broadcast();
    addTearDown(() => unawaited(samples.close()));
    await pumpRouterApp(
      tester,
      database: db,
      samples: samples.stream,
      locale: const Locale('tr'),
      textScale: 2,
    );
    await settleWithDatabase(tester);
    await _tap(tester, 'Aramayı başlat');
    await _tap(tester, 'Atatürk Cad. 12');
    await _tap(tester, 'Enkazın çevresinde noktalarda ölçüm yapın');
    expect(tester.takeException(), isNull);
    await expectFullyReadable(
      tester,
      find.text('Henüz ölçülen nokta yok · 0 tanesinde sinyal var'),
    );
  });
}
