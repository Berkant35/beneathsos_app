// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The export use case; a fresh 16-byte salt per export.

@ProviderFor(exportSearch)
final exportSearchProvider = ExportSearchProvider._();

/// The export use case; a fresh 16-byte salt per export.

final class ExportSearchProvider
    extends $FunctionalProvider<ExportSearch, ExportSearch, ExportSearch>
    with $Provider<ExportSearch> {
  /// The export use case; a fresh 16-byte salt per export.
  ExportSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exportSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exportSearchHash();

  @$internal
  @override
  $ProviderElement<ExportSearch> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ExportSearch create(Ref ref) {
    return exportSearch(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExportSearch value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExportSearch>(value),
    );
  }
}

String _$exportSearchHash() => r'97531441782fe872f665ba50f6918337fdc79bc7';

/// Exports one search.

@ProviderFor(ExportController)
final exportControllerProvider = ExportControllerFamily._();

/// Exports one search.
final class ExportControllerProvider
    extends $NotifierProvider<ExportController, ExportState> {
  /// Exports one search.
  ExportControllerProvider._({
    required ExportControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'exportControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$exportControllerHash();

  @override
  String toString() {
    return r'exportControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ExportController create() => ExportController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExportState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExportState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ExportControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$exportControllerHash() => r'f16ade41da05b60671e1d592820e7148103abe36';

/// Exports one search.

final class ExportControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ExportController,
          ExportState,
          ExportState,
          ExportState,
          String
        > {
  ExportControllerFamily._()
    : super(
        retry: null,
        name: r'exportControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Exports one search.

  ExportControllerProvider call(String sessionId) =>
      ExportControllerProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'exportControllerProvider';
}

/// Exports one search.

abstract class _$ExportController extends $Notifier<ExportState> {
  late final _$args = ref.$arg as String;
  String get sessionId => _$args;

  ExportState build(String sessionId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ExportState, ExportState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ExportState, ExportState>,
              ExportState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
