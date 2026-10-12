import 'package:beneathsos_app/core/sessions/domain/session_store.dart';
import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rubble_core/rubble_core.dart';

part 'searches.g.dart';

/// Every real search, open ones first.
@riverpod
Stream<List<SessionSummary>> searches(Ref ref) =>
    ref.watch(sessionStoreProvider).watchSearches();

/// The projected state of one search (errors with `UnreadableEvent` when stored data is broken).
@riverpod
Stream<SessionState> searchState(Ref ref, String sessionId) =>
    ref.watch(sessionStoreProvider).watch(SessionId(sessionId));
