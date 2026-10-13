// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'research_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The record-where-it-was-found use case.

@ProviderFor(recordFound)
final recordFoundProvider = RecordFoundProvider._();

/// The record-where-it-was-found use case.

final class RecordFoundProvider
    extends $FunctionalProvider<RecordFound, RecordFound, RecordFound>
    with $Provider<RecordFound> {
  /// The record-where-it-was-found use case.
  RecordFoundProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordFoundProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordFoundHash();

  @$internal
  @override
  $ProviderElement<RecordFound> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RecordFound create(Ref ref) {
    return recordFound(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecordFound value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecordFound>(value),
    );
  }
}

String _$recordFoundHash() => r'3234b6a61fd8afb205087411c05a8a40cc68671e';
