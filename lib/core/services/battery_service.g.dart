// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'battery_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// App-wide battery service.

@ProviderFor(battery)
final batteryProvider = BatteryProvider._();

/// App-wide battery service.

final class BatteryProvider
    extends $FunctionalProvider<BatteryPort, BatteryPort, BatteryPort>
    with $Provider<BatteryPort> {
  /// App-wide battery service.
  BatteryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'batteryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$batteryHash();

  @$internal
  @override
  $ProviderElement<BatteryPort> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BatteryPort create(Ref ref) {
    return battery(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BatteryPort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BatteryPort>(value),
    );
  }
}

String _$batteryHash() => r'1fccf38817c4662efc578350cabc2e2af601d64a';
