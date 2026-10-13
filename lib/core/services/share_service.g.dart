// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// App-wide share sheet.

@ProviderFor(share)
final shareProvider = ShareProvider._();

/// App-wide share sheet.

final class ShareProvider
    extends $FunctionalProvider<SharePort, SharePort, SharePort>
    with $Provider<SharePort> {
  /// App-wide share sheet.
  ShareProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shareProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shareHash();

  @$internal
  @override
  $ProviderElement<SharePort> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SharePort create(Ref ref) {
    return share(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharePort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharePort>(value),
    );
  }
}

String _$shareHash() => r'8cfe029034d5e4b9a21810e3a064c879c1343504';
