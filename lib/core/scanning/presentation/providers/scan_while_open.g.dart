// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_while_open.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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
