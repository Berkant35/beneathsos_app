import 'dart:io';

import 'package:beneathsos_app/core/scanning/domain/scan_ports.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permission_service.g.dart';

/// Runtime Bluetooth permissions: for scanning (default) or for victim mode's beacon
/// ([PermissionService.advertising]). On iOS the Bluetooth prompt is triggered by CoreBluetooth
/// itself, so this service only handles Android. Implements [ScanPermissionPort].
class PermissionService implements ScanPermissionPort {
  /// Permissions for scanning.
  const PermissionService()
    : _android = const [Permission.bluetoothScan, Permission.locationWhenInUse];

  /// Permissions for advertising the victim beacon.
  const PermissionService.advertising()
    : _android = const [Permission.bluetoothAdvertise];

  final List<Permission> _android;

  @override
  Future<ScanPermission> check() async {
    if (!Platform.isAndroid) return ScanPermission.granted;
    return _combine([for (final p in _android) await p.status]);
  }

  @override
  Future<ScanPermission> request() async {
    if (!Platform.isAndroid) return ScanPermission.granted;
    final result = await _android.request();
    return _combine(result.values.toList());
  }

  @override
  Future<void> openSettings() async {
    await openAppSettings();
  }

  static ScanPermission _combine(List<PermissionStatus> statuses) {
    if (statuses.every((s) => s.isGranted)) return ScanPermission.granted;
    if (statuses.any((s) => s.isPermanentlyDenied)) {
      return ScanPermission.permanentlyDenied;
    }
    return ScanPermission.denied;
  }
}

/// App-wide permission service.
@Riverpod(keepAlive: true)
PermissionService permissionService(Ref ref) => const PermissionService();

/// Permission to advertise the victim beacon.
@Riverpod(keepAlive: true)
ScanPermissionPort advertisePermission(Ref ref) =>
    const PermissionService.advertising();
