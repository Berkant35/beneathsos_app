import 'dart:io';

import 'package:beneathsos_app/core/scanning/domain/scan_ports.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permission_service.g.dart';

/// Runtime permissions for scanning. On iOS the Bluetooth prompt is triggered by CoreBluetooth
/// itself, so this service only handles Android. Implements [ScanPermissionPort].
class PermissionService implements ScanPermissionPort {
  static const _android = [
    Permission.bluetoothScan,
    Permission.locationWhenInUse,
  ];

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
PermissionService permissionService(Ref ref) => PermissionService();
