import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permission_service.g.dart';

/// Result of a permission check.
enum ScanPermission { granted, denied, permanentlyDenied }

/// Runtime permissions for scanning. On iOS the Bluetooth prompt is triggered by CoreBluetooth
/// itself, so this service only handles Android.
class PermissionService {
  static const _android = [
    Permission.bluetoothScan,
    Permission.locationWhenInUse,
  ];

  /// Current state without prompting.
  Future<ScanPermission> check() async {
    if (!Platform.isAndroid) return ScanPermission.granted;
    return _combine([for (final p in _android) await p.status]);
  }

  /// Prompts for missing permissions.
  Future<ScanPermission> request() async {
    if (!Platform.isAndroid) return ScanPermission.granted;
    final result = await _android.request();
    return _combine(result.values.toList());
  }

  /// Opens the OS settings page of the app.
  Future<bool> openSettings() => openAppSettings();

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
