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

/// A store whose first [failures] appends throw [error]; then it delegates to [inner].
final class _FlakyStore implements SessionStore {
  _FlakyStore(this.inner, this.error);

  final SessionStore inner;
  final Object error;
  int failures = 1;

  /// When true, `create` fails instead of `append`.
  bool failCreate = false;

  @override
  Future<SessionId> create({
    required String title,
    required String engineProfile,
    required bool practice,
  }) {
    if (failCreate) return Future.error(error);
    return inner.create(
      title: title,
      engineProfile: engineProfile,
      practice: practice,
    );
  }

  @override
  Future<void> append(SessionId session, SessionEvent event) {
    if (failures-- > 0) return Future.error(error);
    return inner.append(session, event);
  }

  @override
  Stream<SessionState> watch(SessionId session) => inner.watch(session);

  @override
  Stream<SessionSummary?> watchLatestOpen() => inner.watchLatestOpen();

  @override
  Stream<List<SessionSummary>> watchSearches() => inner.watchSearches();

  @override
  Future<void> addSamples(
    SessionId session,
    PointId? point,
    List<BleSample> samples,
  ) => inner.addSamples(session, point, samples);
}

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
  Stream<List<SessionSummary>> watchSearches() => const Stream.empty();

  @override
  Future<void> addSamples(
    SessionId session,
    PointId? point,
    List<BleSample> samples,
  ) => Future.error(const FormatException('disk full'));
}

SessionSummary _summary(
  SessionId id, {
  required bool practice,
  int measuredPoints = 0,
}) => SessionSummary(
  id: id,
  title: 'Earlier',
  practice: practice,
  createdAt: DateTime(2026),
  measuredPoints: measuredPoints,
  readable: true,
);

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

  test('steps run in order even when the screens do not wait', () async {
    final c = container();
    final practice = c.read(practiceSessionProvider.notifier);
    final started = practice.start('Practice search');
    final drawn = practice.outlineDrawn();
    await Future.wait([started, drawn]);
    final id = c.read(practiceSessionProvider)!;
    final state = await c.read(sessionStoreProvider).watch(id).first;
    expect(state.outline, isNotNull);
  });

  test('a step that fails with an error does not stop later steps', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final c = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(c.dispose);
    final real = c.read(sessionStoreProvider);
    final flaky = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        sessionStoreProvider.overrideWithValue(
          _FlakyStore(real, StateError('bug')),
        ),
      ],
    );
    addTearDown(flaky.dispose);
    final practice = flaky.read(practiceSessionProvider.notifier);
    await practice.start('Practice search');
    await expectLater(practice.outlineDrawn(), throwsStateError);
    await practice.ambientScanned();
    final id = flaky.read(practiceSessionProvider)!;
    expect((await real.watch(id).first).blacklist, hasLength(2));
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
    final practice = c.read(practiceSessionProvider.notifier);
    await practice.resume(_summary(earlier, practice: true));
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

  test(
    'when a new start fails, later steps do not go into the previous search',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final plain = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
      );
      addTearDown(plain.dispose);
      final real = plain.read(sessionStoreProvider);
      final flaky = _FlakyStore(real, const FormatException('disk full'))
        ..failures = 0;
      final c = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          sessionStoreProvider.overrideWithValue(flaky),
        ],
      );
      addTearDown(c.dispose);
      final practice = c.read(practiceSessionProvider.notifier);
      await practice.start('Practice search');
      final first = c.read(practiceSessionProvider)!;
      flaky.failCreate = true;
      await practice.start('Practice search');
      await practice.outlineDrawn();
      expect(c.read(practiceSessionProvider), isNull);
      expect((await real.watch(first).first).outline, isNull);
    },
  );

  test('a real search is never resumed by the practice journey', () async {
    final c = container();
    await c
        .read(practiceSessionProvider.notifier)
        .resume(_summary(const SessionId('real'), practice: false));
    expect(c.read(practiceSessionProvider), isNull);
  });

  test('resume waits for a start that is still running', () async {
    final c = container();
    final store = c.read(sessionStoreProvider);
    final earlier = await store.create(
      title: 'Earlier',
      engineProfile: 'voided_pancake@1',
      practice: true,
    );
    final practice = c.read(practiceSessionProvider.notifier);
    final started = practice.start('Practice search');
    await practice.resume(_summary(earlier, practice: true));
    await started;
    expect(c.read(practiceSessionProvider), earlier);
  });

  test(
    'points after resume do not reuse the positions already measured',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      ProviderContainer app() {
        final c = ProviderContainer(
          overrides: [appDatabaseProvider.overrideWithValue(db)],
        );
        addTearDown(c.dispose);
        return c;
      }

      final before = app();
      await before.read(practiceSessionProvider.notifier).start('Practice');
      await before.read(practiceSessionProvider.notifier).pointMeasured();
      final id = before.read(practiceSessionProvider)!;

      final after = app(); // the app was restarted
      final practice = after.read(practiceSessionProvider.notifier);
      await practice.resume(_summary(id, practice: true, measuredPoints: 1));
      await practice.pointMeasured();
      final state = await after.read(sessionStoreProvider).watch(id).first;
      expect(state.measuredPoints.map((p) => p.at).toSet(), hasLength(2));
    },
  );
}
