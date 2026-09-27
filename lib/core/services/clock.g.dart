// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clock.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Wall clock, overridable in tests.

@ProviderFor(clock)
final clockProvider = ClockProvider._();

/// Wall clock, overridable in tests.

final class ClockProvider
    extends
        $FunctionalProvider<
          DateTime Function(),
          DateTime Function(),
          DateTime Function()
        >
    with $Provider<DateTime Function()> {
  /// Wall clock, overridable in tests.
  ClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockHash();

  @$internal
  @override
  $ProviderElement<DateTime Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DateTime Function() create(Ref ref) {
    return clock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime Function()>(value),
    );
  }
}

String _$clockHash() => r'3f65ad34ac6fcd532de9004042bdf2ed2bd85b13';

/// Ticks once per second for elapsed-time labels.

@ProviderFor(secondTicker)
final secondTickerProvider = SecondTickerProvider._();

/// Ticks once per second for elapsed-time labels.

final class SecondTickerProvider
    extends
        $FunctionalProvider<AsyncValue<DateTime>, DateTime, Stream<DateTime>>
    with $FutureModifier<DateTime>, $StreamProvider<DateTime> {
  /// Ticks once per second for elapsed-time labels.
  SecondTickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secondTickerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secondTickerHash();

  @$internal
  @override
  $StreamProviderElement<DateTime> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<DateTime> create(Ref ref) {
    return secondTicker(ref);
  }
}

String _$secondTickerHash() => r'b35c3970a8e99dcc3286f111998b812b25becbcc';
