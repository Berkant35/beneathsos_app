import 'package:battery_plus/battery_plus.dart';
import 'package:beneathsos_app/core/beacon/domain/beacon_ports.dart';
import 'package:beneathsos_app/core/logging/app_logger.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'battery_service.g.dart';

/// The battery level through `battery_plus`. Implements [BatteryPort].
class BatteryService implements BatteryPort {
  /// Wraps [battery].
  BatteryService(this._battery);

  final Battery _battery;

  /// Null when the platform cannot tell (simulators, some tablets).
  @override
  Future<int?> level() async {
    try {
      return await _battery.batteryLevel;
    } on PlatformException catch (error, stack) {
      AppLogger.error('battery', 'Battery level unavailable', error, stack);
      return null;
    }
  }
}

/// App-wide battery service.
@Riverpod(keepAlive: true)
BatteryPort battery(Ref ref) => BatteryService(Battery());
