// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ble_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// App-wide BLE service.

@ProviderFor(bleService)
final bleServiceProvider = BleServiceProvider._();

/// App-wide BLE service.

final class BleServiceProvider
    extends $FunctionalProvider<BleService, BleService, BleService>
    with $Provider<BleService> {
  /// App-wide BLE service.
  BleServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bleServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bleServiceHash();

  @$internal
  @override
  $ProviderElement<BleService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BleService create(Ref ref) {
    return bleService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BleService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BleService>(value),
    );
  }
}

String _$bleServiceHash() => r'2f4e38cec4f838097a51dc5980579cea05943616';

/// Stream of sample batches.

@ProviderFor(bleSamples)
final bleSamplesProvider = BleSamplesProvider._();

/// Stream of sample batches.

final class BleSamplesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BleSample>>,
          List<BleSample>,
          Stream<List<BleSample>>
        >
    with $FutureModifier<List<BleSample>>, $StreamProvider<List<BleSample>> {
  /// Stream of sample batches.
  BleSamplesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bleSamplesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bleSamplesHash();

  @$internal
  @override
  $StreamProviderElement<List<BleSample>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<BleSample>> create(Ref ref) {
    return bleSamples(ref);
  }
}

String _$bleSamplesHash() => r'04898f273651fc9bae468c4c58964423ab817385';

/// The victim beacon (the same plugin instance as scanning).

@ProviderFor(beaconPort)
final beaconPortProvider = BeaconPortProvider._();

/// The victim beacon (the same plugin instance as scanning).

final class BeaconPortProvider
    extends $FunctionalProvider<BeaconPort, BeaconPort, BeaconPort>
    with $Provider<BeaconPort> {
  /// The victim beacon (the same plugin instance as scanning).
  BeaconPortProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'beaconPortProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$beaconPortHash();

  @$internal
  @override
  $ProviderElement<BeaconPort> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BeaconPort create(Ref ref) {
    return beaconPort(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BeaconPort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BeaconPort>(value),
    );
  }
}

String _$beaconPortHash() => r'37ca951fab8c82d0cb35ce71a4d95e8b1b23912e';
