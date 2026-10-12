import 'dart:math';

import 'package:beneathsos_app/core/database/app_database.dart';
import 'package:beneathsos_app/core/sessions/data/drift_session_store.dart';
import 'package:beneathsos_app/features/preview/presentation/providers/practice_session.dart';
import 'package:beneathsos_app/features/preview/presentation/screens/preview_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubble_core/rubble_core.dart';

import '../../helpers/pump_app.dart';

/// A database holding one open practice search with one measured point, as left by a killed app.
Future<(AppDatabase, SessionId)> _leftBehind(WidgetTester tester) async {
  final db = testDatabase();
  addTearDown(db.close);
  final id = await tester.runAsync(() async {
    final store = DriftSessionStore(
      db,
      nowMs: () => DateTime(2026, 10, 12, 14, 5).millisecondsSinceEpoch,
      random: Random(1),
    );
    final id = await store.create(
      title: 'Practice search',
      engineProfile: 'voided_pancake@1',
      practice: true,
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
      MeasurementCompleted(
        point: point,
        duration: const Duration(seconds: 15),
        readings: [
          SignalHeard(const TargetId('t'), median: const Dbm(-71), samples: 30),
        ],
      ),
    );
    return id;
  });
  return (db, id!);
}

Future<void> _settle(WidgetTester tester) async {
  await tester.runAsync(() => Future<void>.delayed(Duration.zero));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('without an open search there is no card', (tester) async {
    setPhoneSize(tester, 402, 874);
    await pumpRouterApp(tester);
    await _settle(tester);
    expect(find.text('Last practice search'), findsNothing);
    expect(find.text('Last search'), findsNothing);
  });

  testWidgets('an open practice search is offered after a restart', (
    tester,
  ) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _leftBehind(tester);
    await pumpRouterApp(tester, database: db);
    await _settle(tester);
    expect(find.text('Last practice search'), findsOneWidget);
    expect(
      find.text('Practice search · 1 point measured · started 14:05'),
      findsOneWidget,
    );
  });

  testWidgets('Finish closes the search and the card goes away', (
    tester,
  ) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _leftBehind(tester);
    await pumpRouterApp(tester, database: db);
    await _settle(tester);
    await tester.ensureVisible(find.text('Finish this search'));
    await tester.tap(find.text('Finish this search'));
    await _settle(tester);
    expect(find.text('Last practice search'), findsNothing);
    final session = await tester.runAsync(
      () => db.select(db.sessions).getSingle(),
    );
    expect(session!.closedAt, isNotNull);
  });

  testWidgets('Continue opens the map and resumes that search', (tester) async {
    setPhoneSize(tester, 402, 874);
    final (db, id) = await _leftBehind(tester);
    await pumpRouterApp(tester, database: db);
    await _settle(tester);
    await tester.ensureVisible(find.text('Continue the search'));
    await tester.tap(find.text('Continue the search'));
    await _settle(tester);
    expect(find.byType(PreviewMapScreen), findsOneWidget);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(PreviewMapScreen)),
    );
    expect(container.read(practiceSessionProvider), id);
  });

  testWidgets('Turkish card', (tester) async {
    setPhoneSize(tester, 402, 874);
    final (db, _) = await _leftBehind(tester);
    await pumpRouterApp(tester, database: db, locale: const Locale('tr'));
    await _settle(tester);
    expect(find.text('Son alıştırma araması'), findsOneWidget);
    expect(
      find.text('Practice search · 1 nokta ölçüldü · başlangıç 14:05'),
      findsOneWidget,
    );
    expect(find.text('Aramaya devam et'), findsOneWidget);
  });

  testWidgets('the card stays readable at 200 % text on a small phone', (
    tester,
  ) async {
    setPhoneSize(tester, 375, 667);
    final (db, _) = await _leftBehind(tester);
    await pumpRouterApp(tester, database: db, textScale: 2);
    await _settle(tester);
    expect(tester.takeException(), isNull);
    for (final text in [
      'Practice search · 1 point measured · started 14:05',
      'Continue the search',
      'Finish this search',
    ]) {
      await expectFullyReadable(tester, find.text(text));
    }
  });
}
