// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scanning_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Bluetooth radio.

@ProviderFor(scannerPort)
final scannerPortProvider = ScannerPortProvider._();

/// Bluetooth radio.

final class ScannerPortProvider
    extends $FunctionalProvider<ScannerPort, ScannerPort, ScannerPort>
    with $Provider<ScannerPort> {
  /// Bluetooth radio.
  ScannerPortProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scannerPortProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scannerPortHash();

  @$internal
  @override
  $ProviderElement<ScannerPort> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ScannerPort create(Ref ref) {
    return scannerPort(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScannerPort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScannerPort>(value),
    );
  }
}

String _$scannerPortHash() => r'32d305071abe1dd61a2c8eb08a12887f57976aa1';

/// Runtime permissions.

@ProviderFor(scanPermissionPort)
final scanPermissionPortProvider = ScanPermissionPortProvider._();

/// Runtime permissions.

final class ScanPermissionPortProvider
    extends
        $FunctionalProvider<
          ScanPermissionPort,
          ScanPermissionPort,
          ScanPermissionPort
        >
    with $Provider<ScanPermissionPort> {
  /// Runtime permissions.
  ScanPermissionPortProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanPermissionPortProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanPermissionPortHash();

  @$internal
  @override
  $ProviderElement<ScanPermissionPort> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ScanPermissionPort create(Ref ref) {
    return scanPermissionPort(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScanPermissionPort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScanPermissionPort>(value),
    );
  }
}

String _$scanPermissionPortHash() =>
    r'56f09bb128216756e0c147df569a904a5c3e7543';

/// Screen keep-awake.

@ProviderFor(screenAwakePort)
final screenAwakePortProvider = ScreenAwakePortProvider._();

/// Screen keep-awake.

final class ScreenAwakePortProvider
    extends
        $FunctionalProvider<ScreenAwakePort, ScreenAwakePort, ScreenAwakePort>
    with $Provider<ScreenAwakePort> {
  /// Screen keep-awake.
  ScreenAwakePortProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'screenAwakePortProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$screenAwakePortHash();

  @$internal
  @override
  $ProviderElement<ScreenAwakePort> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ScreenAwakePort create(Ref ref) {
    return screenAwakePort(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScreenAwakePort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScreenAwakePort>(value),
    );
  }
}

String _$screenAwakePortHash() => r'73a2309eb200339898071df71775b86f37d72f49';

/// Starts scanning after permission and Bluetooth checks (in this order).

@ProviderFor(startScan)
final startScanProvider = StartScanProvider._();

/// Starts scanning after permission and Bluetooth checks (in this order).

final class StartScanProvider
    extends $FunctionalProvider<StartScan, StartScan, StartScan>
    with $Provider<StartScan> {
  /// Starts scanning after permission and Bluetooth checks (in this order).
  StartScanProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'startScanProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$startScanHash();

  @$internal
  @override
  $ProviderElement<StartScan> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StartScan create(Ref ref) {
    return startScan(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StartScan value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StartScan>(value),
    );
  }
}

String _$startScanHash() => r'362c8e224e46e1ed56e5e58637b034a1edbaad64';

/// Stops scanning.

@ProviderFor(stopScan)
final stopScanProvider = StopScanProvider._();

/// Stops scanning.

final class StopScanProvider
    extends $FunctionalProvider<StopScan, StopScan, StopScan>
    with $Provider<StopScan> {
  /// Stops scanning.
  StopScanProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stopScanProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stopScanHash();

  @$internal
  @override
  $ProviderElement<StopScan> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StopScan create(Ref ref) {
    return stopScan(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StopScan value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StopScan>(value),
    );
  }
}

String _$stopScanHash() => r'53e15d049d1746ecd58492e60a72a5ee7883ad36';
