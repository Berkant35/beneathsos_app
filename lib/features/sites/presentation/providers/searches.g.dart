// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'searches.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Every real search, open ones first.

@ProviderFor(searches)
final searchesProvider = SearchesProvider._();

/// Every real search, open ones first.

final class SearchesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SessionSummary>>,
          List<SessionSummary>,
          Stream<List<SessionSummary>>
        >
    with
        $FutureModifier<List<SessionSummary>>,
        $StreamProvider<List<SessionSummary>> {
  /// Every real search, open ones first.
  SearchesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchesHash();

  @$internal
  @override
  $StreamProviderElement<List<SessionSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<SessionSummary>> create(Ref ref) {
    return searches(ref);
  }
}

String _$searchesHash() => r'45a942bbb827e575ea29ddcc85ff91cac2987ba2';

/// One search (null when it does not exist), straight from the database — not from the list, which
/// may not have caught up with a search created a moment ago.

@ProviderFor(searchSummary)
final searchSummaryProvider = SearchSummaryFamily._();

/// One search (null when it does not exist), straight from the database — not from the list, which
/// may not have caught up with a search created a moment ago.

final class SearchSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<SessionSummary?>,
          SessionSummary?,
          Stream<SessionSummary?>
        >
    with $FutureModifier<SessionSummary?>, $StreamProvider<SessionSummary?> {
  /// One search (null when it does not exist), straight from the database — not from the list, which
  /// may not have caught up with a search created a moment ago.
  SearchSummaryProvider._({
    required SearchSummaryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'searchSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$searchSummaryHash();

  @override
  String toString() {
    return r'searchSummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<SessionSummary?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<SessionSummary?> create(Ref ref) {
    final argument = this.argument as String;
    return searchSummary(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchSummaryHash() => r'6ee01e35050cc1f2c15e74a415a69eace88ef329';

/// One search (null when it does not exist), straight from the database — not from the list, which
/// may not have caught up with a search created a moment ago.

final class SearchSummaryFamily extends $Family
    with $FunctionalFamilyOverride<Stream<SessionSummary?>, String> {
  SearchSummaryFamily._()
    : super(
        retry: null,
        name: r'searchSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One search (null when it does not exist), straight from the database — not from the list, which
  /// may not have caught up with a search created a moment ago.

  SearchSummaryProvider call(String sessionId) =>
      SearchSummaryProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'searchSummaryProvider';
}
