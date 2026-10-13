// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barometer_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The barometer.

@ProviderFor(barometerPort)
final barometerPortProvider = BarometerPortProvider._();

/// The barometer.

final class BarometerPortProvider
    extends $FunctionalProvider<BarometerPort, BarometerPort, BarometerPort>
    with $Provider<BarometerPort> {
  /// The barometer.
  BarometerPortProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'barometerPortProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$barometerPortHash();

  @$internal
  @override
  $ProviderElement<BarometerPort> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BarometerPort create(Ref ref) {
    return barometerPort(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BarometerPort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BarometerPort>(value),
    );
  }
}

String _$barometerPortHash() => r'62329f98464c8f8e344697215da1bfdadae64b3d';

/// This phone's air pressure, while a screen needs it (to compare with a trapped phone's).

@ProviderFor(rescuerPressure)
final rescuerPressureProvider = RescuerPressureProvider._();

/// This phone's air pressure, while a screen needs it (to compare with a trapped phone's).

final class RescuerPressureProvider
    extends $FunctionalProvider<AsyncValue<Hpa>, Hpa, Stream<Hpa>>
    with $FutureModifier<Hpa>, $StreamProvider<Hpa> {
  /// This phone's air pressure, while a screen needs it (to compare with a trapped phone's).
  RescuerPressureProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rescuerPressureProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rescuerPressureHash();

  @$internal
  @override
  $StreamProviderElement<Hpa> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Hpa> create(Ref ref) {
    return rescuerPressure(ref);
  }
}

String _$rescuerPressureHash() => r'017986a40c36973a471d9729a5c80a9fdfd71869';
