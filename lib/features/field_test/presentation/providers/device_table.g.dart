// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_table.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Aggregates samples into tracks and logs identity changes.

@ProviderFor(DeviceTable)
final deviceTableProvider = DeviceTableProvider._();

/// Aggregates samples into tracks and logs identity changes.
final class DeviceTableProvider
    extends $NotifierProvider<DeviceTable, DeviceTableState> {
  /// Aggregates samples into tracks and logs identity changes.
  DeviceTableProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceTableProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceTableHash();

  @$internal
  @override
  DeviceTable create() => DeviceTable();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceTableState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceTableState>(value),
    );
  }
}

String _$deviceTableHash() => r'd9482e8bb851ea00c8c43c12b056445e894449f7';

/// Aggregates samples into tracks and logs identity changes.

abstract class _$DeviceTable extends $Notifier<DeviceTableState> {
  DeviceTableState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DeviceTableState, DeviceTableState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DeviceTableState, DeviceTableState>,
              DeviceTableState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
