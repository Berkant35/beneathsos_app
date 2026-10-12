// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// App-wide permission service.

@ProviderFor(permissionService)
final permissionServiceProvider = PermissionServiceProvider._();

/// App-wide permission service.

final class PermissionServiceProvider
    extends
        $FunctionalProvider<
          PermissionService,
          PermissionService,
          PermissionService
        >
    with $Provider<PermissionService> {
  /// App-wide permission service.
  PermissionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'permissionServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$permissionServiceHash();

  @$internal
  @override
  $ProviderElement<PermissionService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PermissionService create(Ref ref) {
    return permissionService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PermissionService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PermissionService>(value),
    );
  }
}

String _$permissionServiceHash() => r'3114ed43bd440313c5fa4920abc62267985196e6';

/// Permission to advertise the victim beacon.

@ProviderFor(advertisePermission)
final advertisePermissionProvider = AdvertisePermissionProvider._();

/// Permission to advertise the victim beacon.

final class AdvertisePermissionProvider
    extends
        $FunctionalProvider<
          ScanPermissionPort,
          ScanPermissionPort,
          ScanPermissionPort
        >
    with $Provider<ScanPermissionPort> {
  /// Permission to advertise the victim beacon.
  AdvertisePermissionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'advertisePermissionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$advertisePermissionHash();

  @$internal
  @override
  $ProviderElement<ScanPermissionPort> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ScanPermissionPort create(Ref ref) {
    return advertisePermission(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScanPermissionPort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScanPermissionPort>(value),
    );
  }
}

String _$advertisePermissionHash() =>
    r'efb2739cca63eb76abfe6ce60acea380d1d02beb';
