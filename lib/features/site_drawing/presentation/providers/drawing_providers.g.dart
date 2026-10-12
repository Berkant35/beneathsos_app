// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drawing_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stores the outline of a search.

@ProviderFor(setOutline)
final setOutlineProvider = SetOutlineProvider._();

/// Stores the outline of a search.

final class SetOutlineProvider
    extends $FunctionalProvider<SetOutline, SetOutline, SetOutline>
    with $Provider<SetOutline> {
  /// Stores the outline of a search.
  SetOutlineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setOutlineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setOutlineHash();

  @$internal
  @override
  $ProviderElement<SetOutline> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SetOutline create(Ref ref) {
    return setOutline(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SetOutline value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SetOutline>(value),
    );
  }
}

String _$setOutlineHash() => r'cb0ca302a0f90cedc417311b43013eaf672f3b85';

/// Stores the scale of a search.

@ProviderFor(setScale)
final setScaleProvider = SetScaleProvider._();

/// Stores the scale of a search.

final class SetScaleProvider
    extends $FunctionalProvider<SetScale, SetScale, SetScale>
    with $Provider<SetScale> {
  /// Stores the scale of a search.
  SetScaleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setScaleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setScaleHash();

  @$internal
  @override
  $ProviderElement<SetScale> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SetScale create(Ref ref) {
    return setScale(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SetScale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SetScale>(value),
    );
  }
}

String _$setScaleHash() => r'b86fc3818c94426719f0a4cd2ac39a636374062c';

/// One search's projected state (outline, scale) for the drawing screens.

@ProviderFor(drawingSearch)
final drawingSearchProvider = DrawingSearchFamily._();

/// One search's projected state (outline, scale) for the drawing screens.

final class DrawingSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<SessionState>,
          SessionState,
          Stream<SessionState>
        >
    with $FutureModifier<SessionState>, $StreamProvider<SessionState> {
  /// One search's projected state (outline, scale) for the drawing screens.
  DrawingSearchProvider._({
    required DrawingSearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'drawingSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$drawingSearchHash();

  @override
  String toString() {
    return r'drawingSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<SessionState> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<SessionState> create(Ref ref) {
    final argument = this.argument as String;
    return drawingSearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DrawingSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$drawingSearchHash() => r'79fc1252f7b59510774dad4b52ce59513b5c3aa1';

/// One search's projected state (outline, scale) for the drawing screens.

final class DrawingSearchFamily extends $Family
    with $FunctionalFamilyOverride<Stream<SessionState>, String> {
  DrawingSearchFamily._()
    : super(
        retry: null,
        name: r'drawingSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One search's projected state (outline, scale) for the drawing screens.

  DrawingSearchProvider call(String sessionId) =>
      DrawingSearchProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'drawingSearchProvider';
}

/// The outline being drawn for one search, starting from the stored one.

@ProviderFor(OutlineDraftController)
final outlineDraftControllerProvider = OutlineDraftControllerFamily._();

/// The outline being drawn for one search, starting from the stored one.
final class OutlineDraftControllerProvider
    extends $AsyncNotifierProvider<OutlineDraftController, OutlineDraft> {
  /// The outline being drawn for one search, starting from the stored one.
  OutlineDraftControllerProvider._({
    required OutlineDraftControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'outlineDraftControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$outlineDraftControllerHash();

  @override
  String toString() {
    return r'outlineDraftControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  OutlineDraftController create() => OutlineDraftController();

  @override
  bool operator ==(Object other) {
    return other is OutlineDraftControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$outlineDraftControllerHash() =>
    r'a807af27e0030ca16e7318ffa8637f65cd117191';

/// The outline being drawn for one search, starting from the stored one.

final class OutlineDraftControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          OutlineDraftController,
          AsyncValue<OutlineDraft>,
          OutlineDraft,
          FutureOr<OutlineDraft>,
          String
        > {
  OutlineDraftControllerFamily._()
    : super(
        retry: null,
        name: r'outlineDraftControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The outline being drawn for one search, starting from the stored one.

  OutlineDraftControllerProvider call(String sessionId) =>
      OutlineDraftControllerProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'outlineDraftControllerProvider';
}

/// The outline being drawn for one search, starting from the stored one.

abstract class _$OutlineDraftController extends $AsyncNotifier<OutlineDraft> {
  late final _$args = ref.$arg as String;
  String get sessionId => _$args;

  FutureOr<OutlineDraft> build(String sessionId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<OutlineDraft>, OutlineDraft>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<OutlineDraft>, OutlineDraft>,
              AsyncValue<OutlineDraft>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
