import 'dart:async';
import 'dart:math';

import 'package:beneathsos_app/core/beacon/domain/beacon_payload.dart';
import 'package:beneathsos_app/core/beacon/domain/beacon_ports.dart';
import 'package:beneathsos_app/core/beacon/domain/start_beacon.dart';
import 'package:beneathsos_app/core/logging/app_logger.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';
import 'package:beneathsos_app/core/scanning/presentation/providers/scanning_providers.dart';
import 'package:beneathsos_app/core/services/app_lifecycle.dart';
import 'package:beneathsos_app/core/services/battery_service.dart';
import 'package:beneathsos_app/core/services/ble_service.dart';
import 'package:beneathsos_app/core/services/clock.dart';
import 'package:beneathsos_app/core/services/motion_service.dart';
import 'package:beneathsos_app/core/services/permission_service.dart';
import 'package:beneathsos_app/core/services/sos_sound_service.dart';
import 'package:beneathsos_app/features/victim/domain/victim_state.dart';
import 'package:flutter/widgets.dart' show AppLifecycleState;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'victim_providers.g.dart';

/// Draws a beacon id (16 random bits) each time victim mode starts.
@Riverpod(keepAlive: true)
int Function() beaconIdSource(Ref ref) {
  final random = Random.secure();
  return () => random.nextInt(0x10000);
}

/// The start-the-beacon use case.
@riverpod
StartBeacon startBeacon(Ref ref) => StartBeacon(
  ref.watch(beaconPortProvider),
  ref.watch(advertisePermissionProvider),
);

/// Victim mode: calls out as long as the screen is open, with the battery and the time since the
/// phone was last touched or moved refreshed every [refreshEvery]; stops when the screen closes.
@riverpod
class VictimController extends _$VictimController {
  /// How often the payload is refreshed.
  static const refreshEvery = Duration(minutes: 1);

  /// Above this (m/s², gravity removed) the phone was moved: a sign of life.
  static const movedAbove = 0.8;

  late int _id;
  late DateTime _lastTouch;

  @override
  VictimState build() {
    final beacon = ref.watch(beaconPortProvider);
    final screen = ref.watch(screenAwakePortProvider);
    _id = ref.watch(beaconIdSourceProvider)();
    _lastTouch = ref.read(clockProvider)();
    final timer = Timer.periodic(refreshEvery, (_) => unawaited(_refresh()));
    final subscriptions = _listen(beacon);
    unawaited(screen.keepAwake(enabled: true));
    ref.onDispose(() {
      timer.cancel();
      for (final s in subscriptions) {
        unawaited(s.cancel());
      }
      unawaited(beacon.stopAdvertising());
      unawaited(screen.keepAwake(enabled: false));
    });
    unawaited(Future.microtask(retry));
    return const VictimStarting();
  }

  /// Platform failures, movement (a sign of life), Bluetooth turned on, and the return from Settings.
  List<StreamSubscription<Object?>> _listen(BeaconPort beacon) {
    ref.listen(appLifecycleProvider, (_, next) {
      if (next.value == AppLifecycleState.resumed &&
          state is VictimNeedsPermission) {
        unawaited(retry());
      }
    });
    return [
      beacon.advertiseErrors.listen((message) {
        AppLogger.error('victim', 'Beacon stopped: $message');
        state = const VictimFailed();
      }),
      ref
          .watch(motionPortProvider)
          .accelerations
          .where((m) => m > movedAbove)
          .listen((_) => touched()),
      beacon.availabilityChanges.listen((a) {
        if (a == BluetoothAvailability.on && state is VictimBluetoothOff) {
          unawaited(retry());
        }
      }),
    ];
  }

  /// Starts (again) calling out.
  Future<void> retry() async {
    final payload = await _payload();
    final result = await ref.read(startBeaconProvider)(payload);
    if (!ref.mounted) return;
    state = switch (result) {
      BeaconStarted() => VictimCallingOut(payload),
      BeaconNeedsPermission(:final permanently) => VictimNeedsPermission(
        permanently: permanently,
      ),
      BeaconBluetoothOff() => const VictimBluetoothOff(),
      BeaconUnsupported() => const VictimUnsupported(),
    };
  }

  /// Someone touched or moved the phone; after a quiet minute the signal says so at once.
  void touched() {
    final quiet = ref.read(clockProvider)().difference(_lastTouch);
    _lastTouch = ref.read(clockProvider)();
    if (quiet >= refreshEvery) unawaited(_refresh());
  }

  /// Opens the OS settings for Bluetooth access.
  Future<void> openSettings() =>
      ref.read(advertisePermissionProvider).openSettings();

  Future<void> _refresh() async {
    if (state is! VictimCallingOut) return;
    final payload = await _payload();
    await ref.read(beaconPortProvider).advertise(payload);
    if (ref.mounted && state is VictimCallingOut) {
      state = VictimCallingOut(payload);
    }
  }

  Future<BeaconPayload> _payload() async => BeaconPayload(
    id: _id,
    batteryPercent: await ref.read(batteryProvider).level(),
    sinceTouch: ref.read(clockProvider)().difference(_lastTouch),
  );
}

/// Whether the SOS sound plays; it stops when victim mode closes.
@riverpod
class SosSoundController extends _$SosSoundController {
  @override
  bool build() {
    final sound = ref.watch(sosSoundProvider);
    ref.onDispose(() => unawaited(sound.stop()));
    return false;
  }

  /// Plays or stops the sound.
  Future<void> toggle() async {
    final sound = ref.read(sosSoundProvider);
    state = !state;
    await (state ? sound.play() : sound.stop());
  }
}
