// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'depth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stores the depth of a search.

@ProviderFor(setDepth)
final setDepthProvider = SetDepthProvider._();

/// Stores the depth of a search.

final class SetDepthProvider
    extends $FunctionalProvider<SetDepth, SetDepth, SetDepth>
    with $Provider<SetDepth> {
  /// Stores the depth of a search.
  SetDepthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setDepthProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setDepthHash();

  @$internal
  @override
  $ProviderElement<SetDepth> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SetDepth create(Ref ref) {
    return setDepth(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SetDepth value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SetDepth>(value),
    );
  }
}

String _$setDepthHash() => r'262f119e7ac5a754cb55524628b8754cef568ae8';
