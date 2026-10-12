import 'dart:math';

import 'package:beneathsos_app/core/database/app_database.dart';
import 'package:beneathsos_app/core/database/database_provider.dart';
import 'package:beneathsos_app/core/sessions/data/drift_session_store.dart';
import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/features/site_drawing/domain/save_outline_result.dart';
import 'package:beneathsos_app/features/site_drawing/presentation/providers/drawing_providers.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubble_canvas/rubble_canvas.dart';
import 'package:rubble_core/rubble_core.dart';

SitePoint p(double x, double y) => SitePoint(Meters(x), Meters(y));

void main() {
  late AppDatabase db;
  late ProviderContainer c;
  late SessionId search;

  Future<List<String>> types() async => [
    for (final e in await db.select(db.events).get()) e.type,
  ];

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    c = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    search = await DriftSessionStore(
      db,
      nowMs: () => 1000,
      random: Random(1),
    ).create(title: 'Site', engineProfile: 'dense@1', practice: false);
  });
  tearDown(() async {
    c.dispose();
    await db.close();
  });

  OutlineDraftController controller() =>
      c.read(outlineDraftControllerProvider(search.value).notifier);

  Future<OutlineDraft> draft() =>
      c.read(outlineDraftControllerProvider(search.value).future);

  test('a new search starts with an empty outline', () async {
    c.listen(outlineDraftControllerProvider(search.value), (_, _) {});
    expect((await draft()).corners, isEmpty);
  });

  test('an invalid outline is not saved', () async {
    c.listen(outlineDraftControllerProvider(search.value), (_, _) {});
    await draft();
    controller().change(const OutlineDraft.empty().add(p(0, 0)));
    expect(await controller().save(), isA<OutlineNotValid>());
    expect(await types(), ['SiteCreated']);
  });

  test(
    'a valid outline is stored once; saving it unchanged stores nothing',
    () async {
      c.listen(outlineDraftControllerProvider(search.value), (_, _) {});
      await draft();
      controller().change(
        const OutlineDraft.empty().add(p(0, 0)).add(p(10, 0)).add(p(10, 5)),
      );
      expect(await controller().save(), isA<OutlineSaved>());
      expect(await controller().save(), isA<OutlineSaved>());
      expect(await types(), ['SiteCreated', 'RubblePolygonSet']);
    },
  );

  test('a stored outline is where drawing starts again', () async {
    final outline = RubblePolygon([p(0, 0), p(8, 0), p(8, 8)]);
    await c.read(setOutlineProvider).call(search, outline);
    c.listen(outlineDraftControllerProvider(search.value), (_, _) {});
    expect((await draft()).corners, outline.corners);
  });

  test('a scale is stored with its source', () async {
    await c.read(setScaleProvider).call(search, 1.25, ScaleSource.tape);
    final state = await c.read(sessionStoreProvider).watch(search).first;
    expect(state.scale, 1.25);
    expect(await types(), ['SiteCreated', 'ScaleSet']);
  });
}
