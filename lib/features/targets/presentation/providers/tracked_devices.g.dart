// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracked_devices.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Everything the scanner has heard, as an immutable snapshot. Thin: feeds samples and the
/// clock into [DeviceTracker] (where the rules live) and publishes its snapshots.

@ProviderFor(TrackedDevices)
final trackedDevicesProvider = TrackedDevicesProvider._();

/// Everything the scanner has heard, as an immutable snapshot. Thin: feeds samples and the
/// clock into [DeviceTracker] (where the rules live) and publishes its snapshots.
final class TrackedDevicesProvider
    extends $NotifierProvider<TrackedDevices, TrackerSnapshot> {
  /// Everything the scanner has heard, as an immutable snapshot. Thin: feeds samples and the
  /// clock into [DeviceTracker] (where the rules live) and publishes its snapshots.
  TrackedDevicesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trackedDevicesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trackedDevicesHash();

  @$internal
  @override
  TrackedDevices create() => TrackedDevices();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TrackerSnapshot value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TrackerSnapshot>(value),
    );
  }
}

String _$trackedDevicesHash() => r'2f8f89499d8212dae73e056c355755558f913976';

/// Everything the scanner has heard, as an immutable snapshot. Thin: feeds samples and the
/// clock into [DeviceTracker] (where the rules live) and publishes its snapshots.

abstract class _$TrackedDevices extends $Notifier<TrackerSnapshot> {
  TrackerSnapshot build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TrackerSnapshot, TrackerSnapshot>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TrackerSnapshot, TrackerSnapshot>,
              TrackerSnapshot,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
