import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/features/research/domain/record_found.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'research_providers.g.dart';

/// The record-where-it-was-found use case.
@riverpod
RecordFound recordFound(Ref ref) =>
    RecordFound(ref.watch(sessionStoreProvider));
