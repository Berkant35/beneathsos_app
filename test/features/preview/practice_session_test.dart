import 'package:beneathsos_app/core/database/app_database.dart';
import 'package:beneathsos_app/core/database/database_provider.dart';
import 'package:beneathsos_app/core/models/ble_sample.dart';
import 'package:beneathsos_app/core/sessions/domain/session_store.dart';
import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/features/preview/presentation/providers/practice_session.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubble_core/rubble_core.dart';

/// A store whose every write fails, as a full disk would.
final class _BrokenStore implements SessionStore {
  @override
  Future<SessionId> create({
    required String title,
    required String engineProfile,
    required bool practice,
  }) => Future.error(const FormatException('disk full'));

  @override
  Future<void> append(SessionId session, SessionEvent event) =>
      Future.error(const FormatException('disk full'));

  @override
  Stream<SessionState> watch(SessionId session) => const Stream.empty();

  @override
  Stream<SessionSummary?> watchLatestOpen() => const Stream.empty();

  @override
  Future<void> addSamples(
    SessionId session,
    PointId? point,
    List<BleSample> samples,
  ) => Future.error(const FormatException('disk full'));
}

void main() {
  ProviderContainer container() {
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWith((ref) {
          final db = AppDatabase(NativeDatabase.memory());
          ref.onDispose(db.close);
          return db;
        }),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  test('walking the preview journey records a practice search', () async {
    final c = container();
    final practice = c.read(practiceSessionProvider.notifier);
    await practice.start('Practice search');
    await practice.outlineDrawn();
    await practice.ambientScanned();
    await practice.targetChosen();
    await practice.pointMeasured();
    await practice.pointMeasured();

    final id = c.read(practiceSessionProvider)!;
    final state = await c.read(sessionStoreProvider).watch(id).first;
    expect(state.title, 'Practice search');
    expect(state.outline!.area.value, closeTo(18.2 * 12.4, 1e-9));
    expect(state.blacklist, hasLength(2));
    expect(state.targets.values.single.label, 'Apple · Find My');
    expect(state.measuredPoints, hasLength(2));
    final summary = await c.read(sessionStoreProvider).watchLatestOpen().first;
    expect(summary!.practice, isTrue);
  });

  test('discarding sets the point aside', () async {
    final c = container();
    final practice = c.read(practiceSessionProvider.notifier);
    await practice.start('Practice search');
    await practice.pointDiscarded();
    final id = c.read(practiceSessionProvider)!;
    final state = await c.read(sessionStoreProvider).watch(id).first;
    expect(state.points.values.single.status, PointStatus.discarded);
    expect(state.measuredPoints, isEmpty);
  });

  test('a resumed search receives the next steps', () async {
    final c = container();
    final store = c.read(sessionStoreProvider);
    final earlier = await store.create(
      title: 'Earlier',
      engineProfile: 'voided_pancake@1',
      practice: true,
    );
    final practice = c.read(practiceSessionProvider.notifier)..resume(earlier);
    await practice.pointMeasured();
    expect(c.read(practiceSessionProvider), earlier);
    expect((await store.watch(earlier).first).measuredPoints, hasLength(1));
  });

  test('steps before start record nothing and do not fail', () async {
    final c = container();
    await c.read(practiceSessionProvider.notifier).pointMeasured();
    expect(c.read(practiceSessionProvider), isNull);
  });

  test('a failing store never breaks the preview', () async {
    final c = ProviderContainer(
      overrides: [sessionStoreProvider.overrideWithValue(_BrokenStore())],
    );
    addTearDown(c.dispose);
    final practice = c.read(practiceSessionProvider.notifier);
    await practice.start('Practice search');
    await practice.pointMeasured();
    expect(c.read(practiceSessionProvider), isNull);
  });
}
