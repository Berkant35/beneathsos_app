// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_test_filter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Current filter.

@ProviderFor(FieldTestFilter)
final fieldTestFilterProvider = FieldTestFilterProvider._();

/// Current filter.
final class FieldTestFilterProvider
    extends $NotifierProvider<FieldTestFilter, FieldTestFilterState> {
  /// Current filter.
  FieldTestFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fieldTestFilterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fieldTestFilterHash();

  @$internal
  @override
  FieldTestFilter create() => FieldTestFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FieldTestFilterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FieldTestFilterState>(value),
    );
  }
}

String _$fieldTestFilterHash() => r'2a77424d8bc96c4eb1251ba8d8237b780ff7c945';

/// Current filter.

abstract class _$FieldTestFilter extends $Notifier<FieldTestFilterState> {
  FieldTestFilterState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<FieldTestFilterState, FieldTestFilterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FieldTestFilterState, FieldTestFilterState>,
              FieldTestFilterState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
