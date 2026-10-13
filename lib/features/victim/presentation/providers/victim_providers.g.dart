// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'victim_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Draws a beacon id (16 random bits) each time victim mode starts.

@ProviderFor(beaconIdSource)
final beaconIdSourceProvider = BeaconIdSourceProvider._();

/// Draws a beacon id (16 random bits) each time victim mode starts.

final class BeaconIdSourceProvider
    extends $FunctionalProvider<int Function(), int Function(), int Function()>
    with $Provider<int Function()> {
  /// Draws a beacon id (16 random bits) each time victim mode starts.
  BeaconIdSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'beaconIdSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$beaconIdSourceHash();

  @$internal
  @override
  $ProviderElement<int Function()> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int Function() create(Ref ref) {
    return beaconIdSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int Function()>(value),
    );
  }
}

String _$beaconIdSourceHash() => r'36d50d58d0c29352ae70b49e86ed76059279b49c';

/// The start-the-beacon use case.

@ProviderFor(startBeacon)
final startBeaconProvider = StartBeaconProvider._();

/// The start-the-beacon use case.

final class StartBeaconProvider
    extends $FunctionalProvider<StartBeacon, StartBeacon, StartBeacon>
    with $Provider<StartBeacon> {
  /// The start-the-beacon use case.
  StartBeaconProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'startBeaconProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$startBeaconHash();

  @$internal
  @override
  $ProviderElement<StartBeacon> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StartBeacon create(Ref ref) {
    return startBeacon(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StartBeacon value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StartBeacon>(value),
    );
  }
}

String _$startBeaconHash() => r'3c50955fad18c6da557b110006993b65f2b47707';

/// Victim mode: calls out as long as the screen is open — "calling out" only once the platform
/// confirms — with the battery and the time since the phone was last touched or moved refreshed every
/// minute; follows Bluetooth going off and on, tries a failed start again every minute, and stops when
/// the screen closes (also a start still under way).

@ProviderFor(VictimController)
final victimControllerProvider = VictimControllerProvider._();

/// Victim mode: calls out as long as the screen is open — "calling out" only once the platform
/// confirms — with the battery and the time since the phone was last touched or moved refreshed every
/// minute; follows Bluetooth going off and on, tries a failed start again every minute, and stops when
/// the screen closes (also a start still under way).
final class VictimControllerProvider
    extends $NotifierProvider<VictimController, VictimState> {
  /// Victim mode: calls out as long as the screen is open — "calling out" only once the platform
  /// confirms — with the battery and the time since the phone was last touched or moved refreshed every
  /// minute; follows Bluetooth going off and on, tries a failed start again every minute, and stops when
  /// the screen closes (also a start still under way).
  VictimControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'victimControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$victimControllerHash();

  @$internal
  @override
  VictimController create() => VictimController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VictimState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VictimState>(value),
    );
  }
}

String _$victimControllerHash() => r'2fa66e5b286b20a865e21f80b959b1e9f9870f39';

/// Victim mode: calls out as long as the screen is open — "calling out" only once the platform
/// confirms — with the battery and the time since the phone was last touched or moved refreshed every
/// minute; follows Bluetooth going off and on, tries a failed start again every minute, and stops when
/// the screen closes (also a start still under way).

abstract class _$VictimController extends $Notifier<VictimState> {
  VictimState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<VictimState, VictimState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VictimState, VictimState>,
              VictimState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Whether the SOS sound plays; it stops when victim mode closes.

@ProviderFor(SosSoundController)
final sosSoundControllerProvider = SosSoundControllerProvider._();

/// Whether the SOS sound plays; it stops when victim mode closes.
final class SosSoundControllerProvider
    extends $NotifierProvider<SosSoundController, bool> {
  /// Whether the SOS sound plays; it stops when victim mode closes.
  SosSoundControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sosSoundControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sosSoundControllerHash();

  @$internal
  @override
  SosSoundController create() => SosSoundController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$sosSoundControllerHash() =>
    r'84318306e962608d7811cb44c76863d7254671a9';

/// Whether the SOS sound plays; it stops when victim mode closes.

abstract class _$SosSoundController extends $Notifier<bool> {
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
