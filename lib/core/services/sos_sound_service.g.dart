// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sos_sound_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// App-wide SOS sound.

@ProviderFor(sosSound)
final sosSoundProvider = SosSoundProvider._();

/// App-wide SOS sound.

final class SosSoundProvider
    extends $FunctionalProvider<SosSoundPort, SosSoundPort, SosSoundPort>
    with $Provider<SosSoundPort> {
  /// App-wide SOS sound.
  SosSoundProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sosSoundProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sosSoundHash();

  @$internal
  @override
  $ProviderElement<SosSoundPort> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SosSoundPort create(Ref ref) {
    return sosSound(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SosSoundPort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SosSoundPort>(value),
    );
  }
}

String _$sosSoundHash() => r'8c6ce79d90dcd5739803d8cc465058123ff59f5a';
