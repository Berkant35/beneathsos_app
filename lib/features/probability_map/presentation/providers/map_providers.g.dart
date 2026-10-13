// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Runs the engine off the UI isolate (CLAUDE.md §4); tests run it in place.

@ProviderFor(mapEngine)
final mapEngineProvider = MapEngineProvider._();

/// Runs the engine off the UI isolate (CLAUDE.md §4); tests run it in place.

final class MapEngineProvider
    extends $FunctionalProvider<MapEngine, MapEngine, MapEngine>
    with $Provider<MapEngine> {
  /// Runs the engine off the UI isolate (CLAUDE.md §4); tests run it in place.
  MapEngineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapEngineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapEngineHash();

  @$internal
  @override
  $ProviderElement<MapEngine> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MapEngine create(Ref ref) {
    return mapEngine(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MapEngine value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MapEngine>(value),
    );
  }
}

String _$mapEngineHash() => r'5b990dbd913c725540ae77e80604a3ae051bc767';

/// The engine behind a memory of recent runs: an unchanged request is not run again.

@ProviderFor(mapMemo)
final mapMemoProvider = MapMemoProvider._();

/// The engine behind a memory of recent runs: an unchanged request is not run again.

final class MapMemoProvider
    extends $FunctionalProvider<MapMemo, MapMemo, MapMemo>
    with $Provider<MapMemo> {
  /// The engine behind a memory of recent runs: an unchanged request is not run again.
  MapMemoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapMemoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapMemoHash();

  @$internal
  @override
  $ProviderElement<MapMemo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MapMemo create(Ref ref) {
    return mapMemo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MapMemo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MapMemo>(value),
    );
  }
}

String _$mapMemoHash() => r'dbec94d1a5e5490ef945cc522cbb5e058cc92675';

/// The probability map of [targetId] in [sessionId]; null until there is an outline and a point.

@ProviderFor(probabilityMap)
final probabilityMapProvider = ProbabilityMapFamily._();

/// The probability map of [targetId] in [sessionId]; null until there is an outline and a point.

final class ProbabilityMapProvider
    extends
        $FunctionalProvider<
          AsyncValue<TargetMap?>,
          TargetMap?,
          FutureOr<TargetMap?>
        >
    with $FutureModifier<TargetMap?>, $FutureProvider<TargetMap?> {
  /// The probability map of [targetId] in [sessionId]; null until there is an outline and a point.
  ProbabilityMapProvider._({
    required ProbabilityMapFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'probabilityMapProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$probabilityMapHash();

  @override
  String toString() {
    return r'probabilityMapProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<TargetMap?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<TargetMap?> create(Ref ref) {
    final argument = this.argument as (String, String);
    return probabilityMap(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is ProbabilityMapProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$probabilityMapHash() => r'7005e82a58413f54fee707e04be61941d6f97e3e';

/// The probability map of [targetId] in [sessionId]; null until there is an outline and a point.

final class ProbabilityMapFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<TargetMap?>, (String, String)> {
  ProbabilityMapFamily._()
    : super(
        retry: null,
        name: r'probabilityMapProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The probability map of [targetId] in [sessionId]; null until there is an outline and a point.

  ProbabilityMapProvider call(String sessionId, String targetId) =>
      ProbabilityMapProvider._(argument: (sessionId, targetId), from: this);

  @override
  String toString() => r'probabilityMapProvider';
}

/// The suggested next point on the drawing, for the first target (the phone searched for), or null
/// while there is no map.

@ProviderFor(suggestedPoint)
final suggestedPointProvider = SuggestedPointFamily._();

/// The suggested next point on the drawing, for the first target (the phone searched for), or null
/// while there is no map.

final class SuggestedPointProvider
    extends
        $FunctionalProvider<
          AsyncValue<SitePoint?>,
          SitePoint?,
          FutureOr<SitePoint?>
        >
    with $FutureModifier<SitePoint?>, $FutureProvider<SitePoint?> {
  /// The suggested next point on the drawing, for the first target (the phone searched for), or null
  /// while there is no map.
  SuggestedPointProvider._({
    required SuggestedPointFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'suggestedPointProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$suggestedPointHash();

  @override
  String toString() {
    return r'suggestedPointProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SitePoint?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<SitePoint?> create(Ref ref) {
    final argument = this.argument as String;
    return suggestedPoint(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SuggestedPointProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$suggestedPointHash() => r'56e17eeedbf5796529b5c66d42b9e6a0c3a98cbd';

/// The suggested next point on the drawing, for the first target (the phone searched for), or null
/// while there is no map.

final class SuggestedPointFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SitePoint?>, String> {
  SuggestedPointFamily._()
    : super(
        retry: null,
        name: r'suggestedPointProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The suggested next point on the drawing, for the first target (the phone searched for), or null
  /// while there is no map.

  SuggestedPointProvider call(String sessionId) =>
      SuggestedPointProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'suggestedPointProvider';
}

/// Whether the signal circles (a rough guide) are shown, on the map and while measuring — kept in
/// Settings.

@ProviderFor(SignalCircles)
final signalCirclesProvider = SignalCirclesProvider._();

/// Whether the signal circles (a rough guide) are shown, on the map and while measuring — kept in
/// Settings.
final class SignalCirclesProvider
    extends $NotifierProvider<SignalCircles, bool> {
  /// Whether the signal circles (a rough guide) are shown, on the map and while measuring — kept in
  /// Settings.
  SignalCirclesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signalCirclesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signalCirclesHash();

  @$internal
  @override
  SignalCircles create() => SignalCircles();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$signalCirclesHash() => r'89f1fbf212526b2602dbccde783d989f33d0769a';

/// Whether the signal circles (a rough guide) are shown, on the map and while measuring — kept in
/// Settings.

abstract class _$SignalCircles extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
