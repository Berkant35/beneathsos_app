import 'dart:math';

import 'package:beneathsos_app/core/database/database_provider.dart';
import 'package:beneathsos_app/core/services/clock.dart';
import 'package:beneathsos_app/core/sessions/data/drift_session_store.dart';
import 'package:beneathsos_app/core/sessions/domain/session_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_providers.g.dart';

/// Event-sourced sessions on the app database.
@Riverpod(keepAlive: true)
SessionStore sessionStore(Ref ref) {
  final now = ref.watch(clockProvider);
  return DriftSessionStore(
    ref.watch(appDatabaseProvider),
    nowMs: () => now().millisecondsSinceEpoch,
    random: Random.secure(),
  );
}

/// The newest session that is not closed — the home screen offers to continue it.
@riverpod
Stream<SessionSummary?> latestOpenSession(Ref ref) =>
    ref.watch(sessionStoreProvider).watchLatestOpen();
