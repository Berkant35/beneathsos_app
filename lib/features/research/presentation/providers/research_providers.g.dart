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

/// Records where a phone was found: choose (tap the map), confirm, save — once per confirmation.

@ProviderFor(RecordFoundController)
final recordFoundControllerProvider = RecordFoundControllerFamily._();

/// Records where a phone was found: choose (tap the map), confirm, save — once per confirmation.
final class RecordFoundControllerProvider
    extends $NotifierProvider<RecordFoundController, FoundStep> {
  /// Records where a phone was found: choose (tap the map), confirm, save — once per confirmation.
  RecordFoundControllerProvider._({
    required RecordFoundControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'recordFoundControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recordFoundControllerHash();

  @override
  String toString() {
    return r'recordFoundControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RecordFoundController create() => RecordFoundController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FoundStep value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FoundStep>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RecordFoundControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recordFoundControllerHash() =>
    r'009273277dda8ea722e83640fe1d7aa174628ad3';

/// Records where a phone was found: choose (tap the map), confirm, save — once per confirmation.

final class RecordFoundControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          RecordFoundController,
          FoundStep,
          FoundStep,
          FoundStep,
          String
        > {
  RecordFoundControllerFamily._()
    : super(
        retry: null,
        name: r'recordFoundControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Records where a phone was found: choose (tap the map), confirm, save — once per confirmation.

  RecordFoundControllerProvider call(String sessionId) =>
      RecordFoundControllerProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'recordFoundControllerProvider';
}

/// Records where a phone was found: choose (tap the map), confirm, save — once per confirmation.

abstract class _$RecordFoundController extends $Notifier<FoundStep> {
  late final _$args = ref.$arg as String;
  String get sessionId => _$args;

  FoundStep build(String sessionId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<FoundStep, FoundStep>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FoundStep, FoundStep>,
              FoundStep,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
