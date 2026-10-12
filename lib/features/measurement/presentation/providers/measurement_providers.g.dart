// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Places points.

@ProviderFor(placePoint)
final placePointProvider = PlacePointProvider._();

/// Places points.

final class PlacePointProvider
    extends $FunctionalProvider<PlacePoint, PlacePoint, PlacePoint>
    with $Provider<PlacePoint> {
  /// Places points.
  PlacePointProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'placePointProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$placePointHash();

  @$internal
  @override
  $ProviderElement<PlacePoint> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PlacePoint create(Ref ref) {
    return placePoint(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlacePoint value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlacePoint>(value),
    );
  }
}

String _$placePointHash() => r'89bca402f1a8781e708974b2ebfcd52f6cd59da2';

/// Stores measurements.

@ProviderFor(completeMeasurement)
final completeMeasurementProvider = CompleteMeasurementProvider._();

/// Stores measurements.

final class CompleteMeasurementProvider
    extends
        $FunctionalProvider<
          CompleteMeasurement,
          CompleteMeasurement,
          CompleteMeasurement
        >
    with $Provider<CompleteMeasurement> {
  /// Stores measurements.
  CompleteMeasurementProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'completeMeasurementProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$completeMeasurementHash();

  @$internal
  @override
  $ProviderElement<CompleteMeasurement> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CompleteMeasurement create(Ref ref) {
    return completeMeasurement(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CompleteMeasurement value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CompleteMeasurement>(value),
    );
  }
}

String _$completeMeasurementHash() =>
    r'9186cdf8b85ca389e9f76bba2e376d804a8e6aba';

/// Discards points.

@ProviderFor(discardPoint)
final discardPointProvider = DiscardPointProvider._();

/// Discards points.

final class DiscardPointProvider
    extends $FunctionalProvider<DiscardPoint, DiscardPoint, DiscardPoint>
    with $Provider<DiscardPoint> {
  /// Discards points.
  DiscardPointProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'discardPointProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discardPointHash();

  @$internal
  @override
  $ProviderElement<DiscardPoint> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DiscardPoint create(Ref ref) {
    return discardPoint(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiscardPoint value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiscardPoint>(value),
    );
  }
}

String _$discardPointHash() => r'81a0aad8ff53ec3964b734118e2cb55ea302e58c';

/// Relinks targets.

@ProviderFor(relinkTarget)
final relinkTargetProvider = RelinkTargetProvider._();

/// Relinks targets.

final class RelinkTargetProvider
    extends $FunctionalProvider<RelinkTarget, RelinkTarget, RelinkTarget>
    with $Provider<RelinkTarget> {
  /// Relinks targets.
  RelinkTargetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'relinkTargetProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$relinkTargetHash();

  @$internal
  @override
  $ProviderElement<RelinkTarget> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RelinkTarget create(Ref ref) {
    return relinkTarget(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RelinkTarget value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RelinkTarget>(value),
    );
  }
}

String _$relinkTargetHash() => r'23d297973dd293af031abb45a9c5dc5fc1fbe28f';

/// Measuring at points of one search: choose a spot, start, 15 s of still time while scanning, store.

@ProviderFor(MeasurementController)
final measurementControllerProvider = MeasurementControllerFamily._();

/// Measuring at points of one search: choose a spot, start, 15 s of still time while scanning, store.
final class MeasurementControllerProvider
    extends $NotifierProvider<MeasurementController, MeasurementState> {
  /// Measuring at points of one search: choose a spot, start, 15 s of still time while scanning, store.
  MeasurementControllerProvider._({
    required MeasurementControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'measurementControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$measurementControllerHash();

  @override
  String toString() {
    return r'measurementControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MeasurementController create() => MeasurementController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MeasurementState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MeasurementState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MeasurementControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$measurementControllerHash() =>
    r'8be599ca1c3e3db31a83eab2bae2d2763ccf8df9';

/// Measuring at points of one search: choose a spot, start, 15 s of still time while scanning, store.

final class MeasurementControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          MeasurementController,
          MeasurementState,
          MeasurementState,
          MeasurementState,
          String
        > {
  MeasurementControllerFamily._()
    : super(
        retry: null,
        name: r'measurementControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Measuring at points of one search: choose a spot, start, 15 s of still time while scanning, store.

  MeasurementControllerProvider call(String sessionId) =>
      MeasurementControllerProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'measurementControllerProvider';
}

/// Measuring at points of one search: choose a spot, start, 15 s of still time while scanning, store.

abstract class _$MeasurementController extends $Notifier<MeasurementState> {
  late final _$args = ref.$arg as String;
  String get sessionId => _$args;

  MeasurementState build(String sessionId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<MeasurementState, MeasurementState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MeasurementState, MeasurementState>,
              MeasurementState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
