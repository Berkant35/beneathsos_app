import 'dart:async';
import 'dart:math';

import 'package:beneathsos_app/core/database/app_database.dart';
import 'package:beneathsos_app/core/models/ble_sample.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';
import 'package:beneathsos_app/core/sessions/data/drift_session_store.dart';
import 'package:beneathsos_app/core/settings/data/drift_settings_store.dart';
import 'package:beneathsos_app/features/measurement/presentation/screens/measure_screen.dart';
import 'package:beneathsos_app/features/sites/presentation/screens/site_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubble_canvas/rubble_canvas.dart';
import 'package:rubble_core/rubble_core.dart';

import '../../core/scanning/fakes.dart';
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

/// Taps the middle of the map (the middle of the outline: 5, 5 m) — or, with [outside], a spot near
/// the map's corner, around the rubble — then Measure here.
Future<void> _placePoint(WidgetTester tester, {bool outside = false}) async {
  final map = tester.getRect(find.byType(SiteMap));
  await tester.tapAt(outside ? map.topLeft + const Offset(24, 24) : map.center);
  await tester.pump();
  await tester.ensureVisible(find.text('Measure here'));
  await tester.pump();
  await tester.tap(find.text('Measure here'));
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
      // ignore: close_sinks, closed by _open's tear-down
      final samples = await _open(tester, db);
      await _placePoint(tester);
      // A bystander's phone is heard, the target is not.
      await _seconds(
        tester,
        16,
        each: () => samples.add(_heard('bystander', -70)),
      );
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

  testWidgets('after a point, the map suggests where to measure next', (
    tester,
  ) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _search(tester);
    // ignore: close_sinks, closed by _open's tear-down
    final samples = await _open(tester, db);
    List<MapPoint> suggested() => [
      for (final m in tester.widget<SiteMap>(find.byType(SiteMap)).points)
        if (m.kind == MapPointKind.suggested) m,
    ];
    expect(suggested(), isEmpty, reason: 'no map before the first point');
    await _placePoint(tester, outside: true);
    await _seconds(tester, 16, each: () => samples.add(_heard('apple-1', -80)));
    expect(suggested(), hasLength(1));
    // Its signal circle shows on the measuring screen too.
    expect(tester.widget<SiteMap>(find.byType(SiteMap)).circles, hasLength(1));
    expect(find.text('Signal circles (rough guide)'), findsOneWidget);
    // Outside the 10 × 10 m rubble.
    final at = suggested().single.at;
    expect(
      at.x.value < 0 || at.x.value > 10 || at.y.value < 0 || at.y.value > 10,
      isTrue,
    );
  });

  testWidgets('moving pauses the countdown and says why', (tester) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _search(tester);
    final motion = StreamController<double>.broadcast();
    addTearDown(motion.close);
    // ignore: close_sinks, closed by _open's tear-down
    final samples = await _open(tester, db, motion: motion.stream);
    await _placePoint(tester);
    await _seconds(
      tester,
      20,
      each: () {
        motion.add(2);
        samples.add(_heard('apple-1', -80));
      },
    );
    expect(
      find.text('Moving — the count waits until the phone is still.'),
      findsOneWidget,
    );
    expect(await _types(tester, db), isNot(contains('MeasurementCompleted')));
    await _seconds(tester, 18, each: () => samples.add(_heard('apple-1', -80)));
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

  testWidgets(
    'with Bluetooth off nothing counts and no "not heard" is stored',
    (tester) async {
      setPhoneSize(tester, 402, 874);
      final (db, _) = await _search(tester);
      final samples = StreamController<List<BleSample>>.broadcast();
      addTearDown(() => unawaited(samples.close()));
      final scanner = FakeScanner()..availability = BluetoothAvailability.off;
      await pumpRouterApp(
        tester,
        database: db,
        samples: samples.stream,
        scanner: scanner,
      );
      await settleWithDatabase(tester);
      await _tap(tester, 'Start a search');
      await _tap(tester, 'Atatürk Cad. 12');
      await _tap(tester, 'Measure at points around the rubble');
      await _placePoint(tester);
      await _seconds(tester, 30);
      expect(
        find.text("Bluetooth is off. Turn it on in your phone's settings."),
        findsOneWidget,
      );
      expect(await _types(tester, db), isNot(contains('MeasurementCompleted')));
      // The countdown waits: the point is neither stored nor thrown away.
      expect(await _types(tester, db), isNot(contains('MeasurementDiscarded')));
    },
  );

  testWidgets(
    'a point where no device at all was heard is thrown away, never "not heard"',
    (tester) async {
      setPhoneSize(tester, 402, 874);
      final (db, _) = await _search(tester);
      await _open(tester, db);
      await _placePoint(tester);
      await _seconds(tester, 16);
      expect(
        find.text(
          'No Bluetooth device was heard at all — scanning was not working. The point was not stored; measure again.',
        ),
        findsOneWidget,
      );
      final events = (await tester.runAsync(() => db.select(db.events).get()))!;
      expect(events.last.type, 'MeasurementDiscarded');
      expect(
        events.map((e) => e.type),
        isNot(contains('MeasurementCompleted')),
      );
    },
  );

  testWidgets(
    'a point placed but never finished is discarded when measuring opens',
    (tester) async {
      setPhoneSize(tester, 402, 874);
      final (db, id) = await _search(tester);
      await tester.runAsync(
        () =>
            DriftSessionStore(db, nowMs: () => 2000, random: Random(5)).append(
              id,
              const MeasurementPointPlaced(
                point: PointId('left-behind'),
                at: SitePoint(Meters(1), Meters(1)),
              ),
            ),
      );
      await _open(tester, db);
      await settleWithDatabase(tester);
      final events = (await tester.runAsync(() => db.select(db.events).get()))!;
      expect(events.last.type, 'MeasurementDiscarded');
      expect(events.last.payload, contains('left-behind'));
    },
  );

  testWidgets('a double tap on Measure here places one point', (tester) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _search(tester);
    await _open(tester, db);
    await tester.tap(find.byType(SiteMap));
    await tester.pump();
    await tester.ensureVisible(find.text('Measure here'));
    await tester.pump();
    await tester.tap(find.text('Measure here'));
    await tester.tap(find.text('Measure here'), warnIfMissed: false);
    await settleWithDatabase(tester);
    final types = await _types(tester, db);
    expect(types.where((t) => t == 'MeasurementPointPlaced'), hasLength(1));
  });
}
