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
