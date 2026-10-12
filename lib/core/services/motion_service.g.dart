// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'motion_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The motion sensor.

@ProviderFor(motionPort)
final motionPortProvider = MotionPortProvider._();

/// The motion sensor.

final class MotionPortProvider
    extends $FunctionalProvider<MotionPort, MotionPort, MotionPort>
    with $Provider<MotionPort> {
  /// The motion sensor.
  MotionPortProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'motionPortProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$motionPortHash();

  @$internal
  @override
  $ProviderElement<MotionPort> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MotionPort create(Ref ref) {
    return motionPort(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MotionPort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MotionPort>(value),
    );
  }
}

String _$motionPortHash() => r'af9d219294f180d8d3b91eacf08727123a94a55c';
