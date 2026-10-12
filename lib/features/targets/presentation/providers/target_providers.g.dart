// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stores the surface scan.

@ProviderFor(completeAmbientScan)
final completeAmbientScanProvider = CompleteAmbientScanProvider._();

/// Stores the surface scan.

final class CompleteAmbientScanProvider
    extends
        $FunctionalProvider<
          CompleteAmbientScan,
          CompleteAmbientScan,
          CompleteAmbientScan
        >
    with $Provider<CompleteAmbientScan> {
  /// Stores the surface scan.
  CompleteAmbientScanProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'completeAmbientScanProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$completeAmbientScanHash();

  @$internal
  @override
  $ProviderElement<CompleteAmbientScan> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CompleteAmbientScan create(Ref ref) {
    return completeAmbientScan(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CompleteAmbientScan value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CompleteAmbientScan>(value),
    );
  }
}

String _$completeAmbientScanHash() =>
    r'a12887b159bda65ca63bb714299c1b586a547221';

/// Excludes a device.

@ProviderFor(excludeDevice)
final excludeDeviceProvider = ExcludeDeviceProvider._();

/// Excludes a device.

final class ExcludeDeviceProvider
    extends $FunctionalProvider<ExcludeDevice, ExcludeDevice, ExcludeDevice>
    with $Provider<ExcludeDevice> {
  /// Excludes a device.
  ExcludeDeviceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'excludeDeviceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$excludeDeviceHash();

  @$internal
  @override
  $ProviderElement<ExcludeDevice> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ExcludeDevice create(Ref ref) {
    return excludeDevice(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExcludeDevice value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExcludeDevice>(value),
    );
  }
}

String _$excludeDeviceHash() => r'e948fcebf792b19224b48b69abc97c1dbb38e6ec';

/// Selects a target.

@ProviderFor(selectTarget)
final selectTargetProvider = SelectTargetProvider._();

/// Selects a target.

final class SelectTargetProvider
    extends $FunctionalProvider<SelectTarget, SelectTarget, SelectTarget>
    with $Provider<SelectTarget> {
  /// Selects a target.
  SelectTargetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectTargetProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectTargetHash();

  @$internal
  @override
  $ProviderElement<SelectTarget> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SelectTarget create(Ref ref) {
    return selectTarget(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SelectTarget value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SelectTarget>(value),
    );
  }
}

String _$selectTargetHash() => r'b4af15ddc9b765c35085bf3b3daf42fd073549f0';

/// Scans while a screen that needs it is open (surface scan, candidates); shared, so moving from one
/// to the other never stops the scan in between.

@ProviderFor(scanWhileOpen)
final scanWhileOpenProvider = ScanWhileOpenProvider._();

/// Scans while a screen that needs it is open (surface scan, candidates); shared, so moving from one
/// to the other never stops the scan in between.

final class ScanWhileOpenProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Scans while a screen that needs it is open (surface scan, candidates); shared, so moving from one
  /// to the other never stops the scan in between.
  ScanWhileOpenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanWhileOpenProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanWhileOpenHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return scanWhileOpen(ref);
  }
}

String _$scanWhileOpenHash() => r'273d95c152f382c8407cb9066b47c723e73d1a3f';

/// The 30 s surface scan of one search. Counts seconds while scanning (the countdown pauses while
/// Bluetooth is off), then stores the surface phones.

@ProviderFor(AmbientScanController)
final ambientScanControllerProvider = AmbientScanControllerFamily._();

/// The 30 s surface scan of one search. Counts seconds while scanning (the countdown pauses while
/// Bluetooth is off), then stores the surface phones.
final class AmbientScanControllerProvider
    extends $NotifierProvider<AmbientScanController, AmbientState> {
  /// The 30 s surface scan of one search. Counts seconds while scanning (the countdown pauses while
  /// Bluetooth is off), then stores the surface phones.
  AmbientScanControllerProvider._({
    required AmbientScanControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'ambientScanControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ambientScanControllerHash();

  @override
  String toString() {
    return r'ambientScanControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AmbientScanController create() => AmbientScanController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AmbientState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AmbientState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AmbientScanControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ambientScanControllerHash() =>
    r'1f411c5da837b1fd0727d9e6bdd5e8b68a94d8b8';

/// The 30 s surface scan of one search. Counts seconds while scanning (the countdown pauses while
/// Bluetooth is off), then stores the surface phones.

final class AmbientScanControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          AmbientScanController,
          AmbientState,
          AmbientState,
          AmbientState,
          String
        > {
  AmbientScanControllerFamily._()
    : super(
        retry: null,
        name: r'ambientScanControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The 30 s surface scan of one search. Counts seconds while scanning (the countdown pauses while
  /// Bluetooth is off), then stores the surface phones.

  AmbientScanControllerProvider call(String sessionId) =>
      AmbientScanControllerProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'ambientScanControllerProvider';
}

/// The 30 s surface scan of one search. Counts seconds while scanning (the countdown pauses while
/// Bluetooth is off), then stores the surface phones.

abstract class _$AmbientScanController extends $Notifier<AmbientState> {
  late final _$args = ref.$arg as String;
  String get sessionId => _$args;

  AmbientState build(String sessionId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AmbientState, AmbientState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AmbientState, AmbientState>,
              AmbientState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
