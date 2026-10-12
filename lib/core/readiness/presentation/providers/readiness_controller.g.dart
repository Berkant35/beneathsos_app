// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'readiness_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The readiness use case, bound to the app's ports.

@ProviderFor(checkReadiness)
final checkReadinessProvider = CheckReadinessProvider._();

/// The readiness use case, bound to the app's ports.

final class CheckReadinessProvider
    extends $FunctionalProvider<CheckReadiness, CheckReadiness, CheckReadiness>
    with $Provider<CheckReadiness> {
  /// The readiness use case, bound to the app's ports.
  CheckReadinessProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkReadinessProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkReadinessHash();

  @$internal
  @override
  $ProviderElement<CheckReadiness> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CheckReadiness create(Ref ref) {
    return checkReadiness(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CheckReadiness value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CheckReadiness>(value),
    );
  }
}

String _$checkReadinessHash() => r'845dd9249c7239073de49ba85513bcdcc726e634';

/// Device readiness for the home banner. Thin: runs the use case, re-checks on Bluetooth changes
/// and on resume when blocked. Asks for permission automatically once per session; never scans.

@ProviderFor(ReadinessController)
final readinessControllerProvider = ReadinessControllerProvider._();

/// Device readiness for the home banner. Thin: runs the use case, re-checks on Bluetooth changes
/// and on resume when blocked. Asks for permission automatically once per session; never scans.
final class ReadinessControllerProvider
    extends $NotifierProvider<ReadinessController, DeviceReadiness> {
  /// Device readiness for the home banner. Thin: runs the use case, re-checks on Bluetooth changes
  /// and on resume when blocked. Asks for permission automatically once per session; never scans.
  ReadinessControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readinessControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readinessControllerHash();

  @$internal
  @override
  ReadinessController create() => ReadinessController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceReadiness value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceReadiness>(value),
    );
  }
}

String _$readinessControllerHash() =>
    r'4404088fd9b4ba4c738f9a57a31cb9c5edad29b0';

/// Device readiness for the home banner. Thin: runs the use case, re-checks on Bluetooth changes
/// and on resume when blocked. Asks for permission automatically once per session; never scans.

abstract class _$ReadinessController extends $Notifier<DeviceReadiness> {
  DeviceReadiness build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DeviceReadiness, DeviceReadiness>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DeviceReadiness, DeviceReadiness>,
              DeviceReadiness,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
