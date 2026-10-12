import 'package:beneathsos_app/core/sessions/domain/session_store.dart';
import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rubble_core/rubble_core.dart';

part 'searches.g.dart';

/// Every real search, open ones first.
@riverpod
Stream<List<SessionSummary>> searches(Ref ref) =>
    ref.watch(sessionStoreProvider).watchSearches();

/// One search (null when it does not exist), straight from the database — not from the list, which
/// may not have caught up with a search created a moment ago.
@riverpod
Stream<SessionSummary?> searchSummary(Ref ref, String sessionId) =>
    ref.watch(sessionStoreProvider).watchSummary(SessionId(sessionId));
