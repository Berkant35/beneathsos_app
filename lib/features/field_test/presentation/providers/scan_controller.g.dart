// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Starts/stops the scanner and guards permissions and adapter state.

@ProviderFor(ScanController)
final scanControllerProvider = ScanControllerProvider._();

/// Starts/stops the scanner and guards permissions and adapter state.
final class ScanControllerProvider
    extends $NotifierProvider<ScanController, ScanState> {
  /// Starts/stops the scanner and guards permissions and adapter state.
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

String _$scanControllerHash() => r'f30c2e36a8fca8d4630b2be49529b6fcd13dce37';

/// Starts/stops the scanner and guards permissions and adapter state.

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
