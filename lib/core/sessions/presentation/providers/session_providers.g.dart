// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Event-sourced sessions on the app database.

@ProviderFor(sessionStore)
final sessionStoreProvider = SessionStoreProvider._();

/// Event-sourced sessions on the app database.

final class SessionStoreProvider
    extends $FunctionalProvider<SessionStore, SessionStore, SessionStore>
    with $Provider<SessionStore> {
  /// Event-sourced sessions on the app database.
  SessionStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionStoreHash();

  @$internal
  @override
  $ProviderElement<SessionStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SessionStore create(Ref ref) {
    return sessionStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionStore>(value),
    );
  }
}

String _$sessionStoreHash() => r'c5fb1af705afe860eb556ff2000eb676a5805989';

/// The newest session that is not closed — the home screen offers to continue it.

@ProviderFor(latestOpenSession)
final latestOpenSessionProvider = LatestOpenSessionProvider._();

/// The newest session that is not closed — the home screen offers to continue it.

final class LatestOpenSessionProvider
    extends
        $FunctionalProvider<
          AsyncValue<SessionSummary?>,
          SessionSummary?,
          Stream<SessionSummary?>
        >
    with $FutureModifier<SessionSummary?>, $StreamProvider<SessionSummary?> {
  /// The newest session that is not closed — the home screen offers to continue it.
  LatestOpenSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'latestOpenSessionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$latestOpenSessionHash();

  @$internal
  @override
  $StreamProviderElement<SessionSummary?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<SessionSummary?> create(Ref ref) {
    return latestOpenSession(ref);
  }
}

String _$latestOpenSessionHash() => r'bff7c6e53d4554fd700b14a6843b71fa3dc705c2';

/// Finishes a search.

@ProviderFor(finishSearch)
final finishSearchProvider = FinishSearchProvider._();

/// Finishes a search.

final class FinishSearchProvider
    extends $FunctionalProvider<FinishSearch, FinishSearch, FinishSearch>
    with $Provider<FinishSearch> {
  /// Finishes a search.
  FinishSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'finishSearchProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$finishSearchHash();

  @$internal
  @override
  $ProviderElement<FinishSearch> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FinishSearch create(Ref ref) {
    return finishSearch(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FinishSearch value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FinishSearch>(value),
    );
  }
}

String _$finishSearchHash() => r'1653fb52755997da34e588d755d1cb68dab3d8eb';

/// One session's projected state, updated after every event (errors with `UnreadableEvent` when stored
/// data is broken).

@ProviderFor(sessionState)
final sessionStateProvider = SessionStateFamily._();

/// One session's projected state, updated after every event (errors with `UnreadableEvent` when stored
/// data is broken).

final class SessionStateProvider
    extends
        $FunctionalProvider<
          AsyncValue<SessionState>,
          SessionState,
          Stream<SessionState>
        >
    with $FutureModifier<SessionState>, $StreamProvider<SessionState> {
  /// One session's projected state, updated after every event (errors with `UnreadableEvent` when stored
  /// data is broken).
  SessionStateProvider._({
    required SessionStateFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sessionStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sessionStateHash();

  @override
  String toString() {
    return r'sessionStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<SessionState> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<SessionState> create(Ref ref) {
    final argument = this.argument as String;
    return sessionState(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sessionStateHash() => r'760c0b085d71e95ab58b9704d2e3e109686ebb8d';

/// One session's projected state, updated after every event (errors with `UnreadableEvent` when stored
/// data is broken).

final class SessionStateFamily extends $Family
    with $FunctionalFamilyOverride<Stream<SessionState>, String> {
  SessionStateFamily._()
    : super(
        retry: null,
        name: r'sessionStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One session's projected state, updated after every event (errors with `UnreadableEvent` when stored
  /// data is broken).

  SessionStateProvider call(String sessionId) =>
      SessionStateProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'sessionStateProvider';
}

/// The delete-a-search use case.

@ProviderFor(deleteSearch)
final deleteSearchProvider = DeleteSearchProvider._();

/// The delete-a-search use case.

final class DeleteSearchProvider
    extends $FunctionalProvider<DeleteSearch, DeleteSearch, DeleteSearch>
    with $Provider<DeleteSearch> {
  /// The delete-a-search use case.
  DeleteSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteSearchProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteSearchHash();

  @$internal
  @override
  $ProviderElement<DeleteSearch> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeleteSearch create(Ref ref) {
    return deleteSearch(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteSearch value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteSearch>(value),
    );
  }
}

String _$deleteSearchHash() => r'496634ffa9e1a7befcdedcd39ce0b68b0aa5b737';
