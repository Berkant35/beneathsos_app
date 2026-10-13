import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:beneathsos_app/core/beacon/domain/beacon_payload.dart';
import 'package:beneathsos_app/core/database/app_database.dart';
import 'package:beneathsos_app/core/models/ble_sample.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';
import 'package:beneathsos_app/core/sessions/data/drift_session_store.dart';
import 'package:beneathsos_app/core/settings/data/drift_settings_store.dart';
import 'package:beneathsos_app/features/sites/presentation/screens/site_screen.dart';
import 'package:beneathsos_app/features/targets/presentation/screens/ambient_scan_screen.dart';
import 'package:beneathsos_app/features/targets/presentation/screens/targets_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubble_core/rubble_core.dart';

import '../../../core/beacon/fakes.dart';
import '../../../core/scanning/fakes.dart';
import '../../../helpers/pump_app.dart';

var _clock = 0;

/// [count] readings of [key] at [rssi]; [findMy] makes it an Apple Find My advertisement.
List<BleSample> _heard(
  String key,
  int rssi, {
  int count = 6,
  bool findMy = false,
}) => [
  for (var i = 0; i < count; i++)
    BleSample(
      key: key,
      rssi: rssi,
      serviceUuids: const [],
      monotonicNanos: _clock,
      // The tracker forgets devices silent for 30 s by the wall clock: stamp readings with it.
      wallClockMillis: DateTime.now().millisecondsSinceEpoch + _clock++,
      companyId: findMy ? 0x004C : null,
      payload: findMy ? Uint8List.fromList([0x12, 0x19]) : null,
    ),
];

Future<void> _tap(WidgetTester tester, String label) async {
  await tester.ensureVisible(find.text(label).first);
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).first);
  await settleWithDatabase(tester);
}

/// Opens a screen that counts down (the surface scan) without settling: settling would run the whole
/// 30 s countdown at once.
Future<void> _open(WidgetTester tester, String label) async {
  await tester.ensureVisible(find.text(label).first);
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).first);
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

Future<(AppDatabase, SessionId)> _search(
  WidgetTester tester, {
  List<String> surface = const [],
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
    if (surface.isNotEmpty) {
      await store.append(
        id,
        AmbientScanCompleted(
          blacklisted: surface,
          duration: const Duration(seconds: 30),
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

void main() {
  setUp(() => _clock = 0);

  testWidgets(
    'the surface scan sets strong phones aside and keeps faint ones',
    (tester) async {
      setPhoneSize(tester, 402, 874);
      final (db, _) = await _search(tester);
      final samples = StreamController<List<BleSample>>.broadcast();
      // Not awaited: a paused subscription never receives the done event.
      addTearDown(() => unawaited(samples.close()));
      final scanner = FakeScanner();
      await pumpRouterApp(
        tester,
        database: db,
        samples: samples.stream,
        scanner: scanner,
      );
      await settleWithDatabase(tester);
      await _tap(tester, 'Start a search');
      await _tap(tester, 'Atatürk Cad. 12');
      await _open(tester, 'Find the phones on the surface');
      expect(find.byType(AmbientScanScreen), findsOneWidget);
      expect(scanner.calls, contains('start'));
      samples
        ..add(_heard('team', -60))
        ..add(_heard('buried', -88));
      for (var s = 0; s < 32; s++) {
        await tester.pump(const Duration(seconds: 1));
      }
      await settleWithDatabase(tester);
      expect(
        find.text('1 surface phone set aside. It will not be suggested.'),
        findsOneWidget,
      );
      final events = (await tester.runAsync(() => db.select(db.events).get()))!;
      expect(events.last.type, 'AmbientScanCompleted');
      expect(events.last.payload, contains('"team"'));
      expect(events.last.payload, isNot(contains('"buried"')));
      await _tap(tester, 'Back to the search');
      expect(find.byType(SiteScreen), findsOneWidget);
      expect(find.text('Done · 1 phone set aside'), findsOneWidget);
      expect(scanner.calls.last, 'stop');
    },
  );

  testWidgets('Bluetooth off pauses the surface scan and says so', (
    tester,
  ) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _search(tester);
    final scanner = FakeScanner()..availability = BluetoothAvailability.off;
    await pumpRouterApp(tester, database: db, scanner: scanner);
    await settleWithDatabase(tester);
    await _tap(tester, 'Start a search');
    await _tap(tester, 'Atatürk Cad. 12');
    await _open(tester, 'Find the phones on the surface');
    await tester.pump(const Duration(seconds: 2));
    expect(
      find.text("Bluetooth is off. Turn it on in your phone's settings."),
      findsWidgets,
    );
    final events = await _types(tester, db);
    expect(events, isNot(contains('AmbientScanCompleted')));
  });

  testWidgets(
    'candidates: Find My first, exclude sets one aside, track follows one',
    (tester) async {
      setPhoneSize(tester, 402, 874);
      final (db, _) = await _search(tester, surface: ['team']);
      final samples = StreamController<List<BleSample>>.broadcast();
      // Not awaited: a paused subscription never receives the done event.
      addTearDown(() => unawaited(samples.close()));
      await pumpRouterApp(tester, database: db, samples: samples.stream);
      await settleWithDatabase(tester);
      await _tap(tester, 'Start a search');
      await _tap(tester, 'Atatürk Cad. 12');
      await _tap(tester, 'Choose the phone to search for');
      expect(find.byType(TargetsScreen), findsOneWidget);
      expect(
        find.text('No phones heard yet. Keep this screen open.'),
        findsOneWidget,
      );
      samples
        ..add(_heard('team', -60))
        ..add(_heard('other', -85))
        ..add(_heard('apple', -88, findMy: true));
      await tester.pump();
      await tester.pump(); // the stream event, then the rebuild
      final titles = tester
          .widgetList<Text>(
            find.textContaining(RegExp('Apple · Find My|Unknown device')),
          )
          .map((t) => t.data)
          .toList();
      expect(titles.first, 'Apple · Find My');
      expect(
        find.text('Not moving · weak signal · not strong in the surface scan'),
        findsNWidgets(2),
      );
      expect(find.text('Signal −88 dBm'), findsOneWidget);
      // The surface phone is not offered.
      expect(find.text('Signal −60 dBm'), findsNothing);
      await _tap(tester, 'Exclude — it is on the surface');
      expect(find.text('Apple · Find My'), findsNothing);
      await _tap(tester, 'Track this phone');
      expect(find.byType(SiteScreen), findsOneWidget);
      // No manufacturer data: an unknown device.
      expect(find.text('Done · Unknown device'), findsOneWidget);
      expect(await _types(tester, db), [
        'SiteCreated',
        'AmbientScanCompleted',
        'BlacklistEdited',
        'TargetSelected',
      ]);
    },
  );

  testWidgets(
    'a trapped phone with a barometer: its card says how deep, coarsely',
    (tester) async {
      setPhoneSize(tester, 402, 874);
      final (db, _) = await _search(tester, surface: ['team']);
      final samples = StreamController<List<BleSample>>.broadcast();
      addTearDown(() => unawaited(samples.close()));
      final fakes = BeaconFakes();
      await pumpRouterApp(
        tester,
        database: db,
        samples: samples.stream,
        beacon: fakes,
      );
      await settleWithDatabase(tester);
      await _tap(tester, 'Start a search');
      await _tap(tester, 'Atatürk Cad. 12');
      await _tap(tester, 'Choose the phone to search for');
      // The rescuer's own barometer, then an iOS victim naming its pressure (0.9 hPa higher: ~7.5 m).
      fakes.barometer.readings.add(const Hpa(1012.3));
      samples.add([
        for (var i = 0; i < 6; i++)
          BleSample(
            key: 'AA-BB',
            rssi: -85,
            serviceUuids: const [beaconServiceUuid],
            localName: 'SOS-1A2B-10132',
            monotonicNanos: _clock,
            wallClockMillis: DateTime.now().millisecondsSinceEpoch + _clock++,
          ),
      ]);
      await tester.pump();
      await tester.pump();
      expect(
        find.text('Its barometer: 1–3 floors below you (± 8 m).'),
        findsOneWidget,
      );
    },
  );

  testWidgets('without a surface scan the list says so and offers it', (
    tester,
  ) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _search(tester);
    await pumpRouterApp(tester, database: db);
    await settleWithDatabase(tester);
    await _tap(tester, 'Start a search');
    await _tap(tester, 'Atatürk Cad. 12');
    await _tap(tester, 'Choose the phone to search for');
    await _open(
      tester,
      "No surface scan yet: rescuers' phones may be listed. Tap to scan first.",
    );
    expect(find.byType(AmbientScanScreen), findsOneWidget);
  });

  testWidgets('Turkish at 200 % on a small phone: a candidate stays readable', (
    tester,
  ) async {
    setPhoneSize(tester, 375, 667);
    final (db, _) = await _search(tester, surface: ['team']);
    final samples = StreamController<List<BleSample>>.broadcast();
    // Not awaited: a paused subscription never receives the done event.
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
    await _tap(tester, 'Aranacak telefonu seçin');
    samples.add(_heard('apple', -88, findMy: true));
    await tester.pump();
    await tester.pump(); // the stream event, then the rebuild
    expect(tester.takeException(), isNull);
    await expectFullyReadable(
      tester,
      find.text('Hareketsiz · zayıf sinyal · yüzey taramasında güçlü değildi'),
    );
    await expectFullyReadable(tester, find.text('Hariç tut — yüzeyde'));
  });

  Future<StreamController<List<BleSample>>> openTargets(
    WidgetTester tester,
    AppDatabase db,
  ) async {
    final samples = StreamController<List<BleSample>>.broadcast();
    // Not awaited: a paused subscription never receives the done event.
    addTearDown(() => unawaited(samples.close()));
    await pumpRouterApp(tester, database: db, samples: samples.stream);
    await settleWithDatabase(tester);
    await _tap(tester, 'Start a search');
    await _tap(tester, 'Atatürk Cad. 12');
    await _tap(tester, 'Choose the phone to search for');
    return samples;
  }

  Future<void> hear(
    WidgetTester tester,
    StreamController<List<BleSample>> samples,
    List<BleSample> batch,
  ) async {
    samples.add(batch);
    await tester.pump();
    await tester.pump();
  }

  testWidgets('Exclude offers Undo; Undo puts the phone back', (tester) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _search(tester, surface: ['team']);
    final samples = await openTargets(tester, db);
    await hear(tester, samples, _heard('apple', -88, findMy: true));
    await _tap(tester, 'Exclude — it is on the surface');
    expect(find.text('Set aside: Apple · Find My.'), findsOneWidget);
    expect(find.text('Track this phone'), findsNothing);
    await _tap(tester, 'Undo');
    expect(find.text('Track this phone'), findsOneWidget);
    expect(await _types(tester, db), [
      'SiteCreated',
      'AmbientScanCompleted',
      'BlacklistEdited',
      'BlacklistEdited',
    ]);
  });

  testWidgets('phones set aside are listed and can be put back', (
    tester,
  ) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _search(tester, surface: ['team']);
    final samples = await openTargets(tester, db);
    await hear(tester, samples, _heard('team', -60));
    await _tap(tester, 'Set aside (1)');
    expect(find.text('Unknown device · Signal −60 dBm'), findsOneWidget);
    await _tap(tester, 'Put back');
    expect(find.text('Track this phone'), findsOneWidget);
  });

  testWidgets('a phone heard only a few times is never called moving', (
    tester,
  ) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _search(tester, surface: ['team']);
    final samples = await openTargets(tester, db);
    await hear(tester, samples, _heard('faint', -96, count: 2));
    expect(
      find.text(
        'Heard only a few times so far · weak signal · not strong in the surface scan',
      ),
      findsOneWidget,
    );
  });

  testWidgets('cards keep their place; Sort again re-ranks', (tester) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _search(tester, surface: ['team']);
    final samples = await openTargets(tester, db);
    await hear(tester, samples, _heard('other', -85));
    await hear(tester, samples, _heard('apple', -88, findMy: true));
    List<String?> titles() => tester
        .widgetList<Text>(
          find.textContaining(RegExp(r'^(Apple · Find My|Unknown device)$')),
        )
        .map((t) => t.data)
        .toList();
    expect(titles(), ['Unknown device', 'Apple · Find My']);
    await _tap(tester, 'Sort again');
    expect(titles(), ['Apple · Find My', 'Unknown device']);
  });

  testWidgets('a double tap on Track follows one phone', (tester) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _search(tester, surface: ['team']);
    final samples = await openTargets(tester, db);
    await hear(tester, samples, _heard('apple', -88, findMy: true));
    await tester.ensureVisible(find.text('Track this phone'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Track this phone'));
    await tester.tap(find.text('Track this phone'), warnIfMissed: false);
    await settleWithDatabase(tester);
    final types = await _types(tester, db);
    expect(types.where((t) => t == 'TargetSelected'), hasLength(1));
  });

  testWidgets('a surface scan that set nothing aside still counts as done', (
    tester,
  ) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _search(tester);
    final scanner = FakeScanner();
    await pumpRouterApp(tester, database: db, scanner: scanner);
    await settleWithDatabase(tester);
    await _tap(tester, 'Start a search');
    await _tap(tester, 'Atatürk Cad. 12');
    await _open(tester, 'Find the phones on the surface');
    for (var s = 0; s < 32; s++) {
      await tester.pump(const Duration(seconds: 1));
    }
    await settleWithDatabase(tester);
    expect(
      find.text('No phone close by: nothing was set aside.'),
      findsOneWidget,
    );
    await _tap(tester, 'Back to the search');
    expect(find.text('Done · nothing set aside'), findsOneWidget);
    await _tap(tester, 'Choose the phone to search for');
    expect(
      find.text(
        "No surface scan yet: rescuers' phones may be listed. Tap to scan first.",
      ),
      findsNothing,
    );
  });

  testWidgets(
    'the surface scan countdown waits while the app is in the background',
    (tester) async {
      setPhoneSize(tester, 402, 874);
      final (db, _) = await _search(tester);
      final lifecycle = StreamController<AppLifecycleState>.broadcast();
      addTearDown(() => unawaited(lifecycle.close()));
      await pumpRouterApp(tester, database: db, lifecycle: lifecycle.stream);
      await settleWithDatabase(tester);
      await _tap(tester, 'Start a search');
      await _tap(tester, 'Atatürk Cad. 12');
      await _open(tester, 'Find the phones on the surface');
      lifecycle.add(AppLifecycleState.paused);
      for (var s = 0; s < 40; s++) {
        await tester.pump(const Duration(seconds: 1));
      }
      await settleWithDatabase(tester);
      expect(await _types(tester, db), isNot(contains('AmbientScanCompleted')));
      lifecycle.add(AppLifecycleState.resumed);
      for (var s = 0; s < 32; s++) {
        await tester.pump(const Duration(seconds: 1));
      }
      await settleWithDatabase(tester);
      expect(await _types(tester, db), contains('AmbientScanCompleted'));
    },
  );
}
