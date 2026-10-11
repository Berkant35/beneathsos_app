// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Scanner state for the UI. Thin: calls use cases, maps results, wires streams.
/// Rules live in `core/scanning/domain`.

@ProviderFor(ScanController)
final scanControllerProvider = ScanControllerProvider._();

/// Scanner state for the UI. Thin: calls use cases, maps results, wires streams.
/// Rules live in `core/scanning/domain`.
final class ScanControllerProvider
    extends $NotifierProvider<ScanController, ScanState> {
  /// Scanner state for the UI. Thin: calls use cases, maps results, wires streams.
  /// Rules live in `core/scanning/domain`.
  ScanControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanControllerHash();

  @$internal
  @override
  ScanController create() => ScanController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScanState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScanState>(value),
    );
  }
}

String _$scanControllerHash() => r'72b8caf30117fc55dec6d8a5d88f41627e200382';

/// Scanner state for the UI. Thin: calls use cases, maps results, wires streams.
/// Rules live in `core/scanning/domain`.

abstract class _$ScanController extends $Notifier<ScanState> {
  ScanState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ScanState, ScanState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ScanState, ScanState>,
              ScanState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
