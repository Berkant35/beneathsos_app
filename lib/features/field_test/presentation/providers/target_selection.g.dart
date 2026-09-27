// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target_selection.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Identities the tester marked as measurement targets.

@ProviderFor(TargetSelection)
final targetSelectionProvider = TargetSelectionProvider._();

/// Identities the tester marked as measurement targets.
final class TargetSelectionProvider
    extends $NotifierProvider<TargetSelection, Set<String>> {
  /// Identities the tester marked as measurement targets.
  TargetSelectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'targetSelectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$targetSelectionHash();

  @$internal
  @override
  TargetSelection create() => TargetSelection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$targetSelectionHash() => r'aece6b703af295b56669b1653a812a15864e5b30';

/// Identities the tester marked as measurement targets.

abstract class _$TargetSelection extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
