// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wakelock_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// App-wide wakelock service.

@ProviderFor(wakelockService)
final wakelockServiceProvider = WakelockServiceProvider._();

/// App-wide wakelock service.

final class WakelockServiceProvider
    extends
        $FunctionalProvider<WakelockService, WakelockService, WakelockService>
    with $Provider<WakelockService> {
  /// App-wide wakelock service.
  WakelockServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wakelockServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wakelockServiceHash();

  @$internal
  @override
  $ProviderElement<WakelockService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WakelockService create(Ref ref) {
    return wakelockService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WakelockService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WakelockService>(value),
    );
  }
}

String _$wakelockServiceHash() => r'e1feace447870d5be186a270967a4944a924594f';
