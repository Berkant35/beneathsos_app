// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_search.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Creates real searches. The state is true while one is being created, so a double tap makes one.

@ProviderFor(NewSearch)
final newSearchProvider = NewSearchProvider._();

/// Creates real searches. The state is true while one is being created, so a double tap makes one.
final class NewSearchProvider extends $NotifierProvider<NewSearch, bool> {
  /// Creates real searches. The state is true while one is being created, so a double tap makes one.
  NewSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newSearchHash();

  @$internal
  @override
  NewSearch create() => NewSearch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$newSearchHash() => r'4fe695ca6716cb8e4edce5524ae62ea4984cc970';

/// Creates real searches. The state is true while one is being created, so a double tap makes one.

abstract class _$NewSearch extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
