import 'dart:async';
import 'dart:math';

import 'package:beneathsos_app/core/beacon/domain/beacon_payload.dart';
import 'package:beneathsos_app/core/beacon/domain/beacon_ports.dart';
import 'package:beneathsos_app/core/beacon/domain/start_beacon.dart';
import 'package:beneathsos_app/core/logging/app_logger.dart';
import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';
import 'package:beneathsos_app/core/scanning/presentation/providers/scanning_providers.dart';
import 'package:beneathsos_app/core/services/app_lifecycle.dart';
import 'package:beneathsos_app/core/services/barometer_service.dart';
import 'package:beneathsos_app/core/services/battery_service.dart';
import 'package:beneathsos_app/core/services/ble_service.dart';
import 'package:beneathsos_app/core/services/clock.dart';
import 'package:beneathsos_app/core/services/motion_service.dart';
import 'package:beneathsos_app/core/services/permission_service.dart';
import 'package:beneathsos_app/core/services/sos_sound_service.dart';
import 'package:beneathsos_app/features/victim/domain/liveness.dart';
import 'package:beneathsos_app/features/victim/domain/victim_state.dart';
import 'package:flutter/widgets.dart' show AppLifecycleState;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rubble_core/rubble_core.dart' show Hpa;

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

/// Victim mode: calls out as long as the screen is open — "calling out" only once the platform
/// confirms — with the battery and the time since the phone was last touched or moved refreshed every
/// minute; follows Bluetooth going off and on, tries a failed start again every minute, and stops when
/// the screen closes (also a start still under way).
@riverpod
class VictimController extends _$VictimController {
  /// Above this (m/s², gravity removed) the phone was moved: a sign of life.
  static const movedAbove = 0.8;

  late int _id;
  late Liveness _liveness;

  /// The payload last handed to the radio, shown once the platform confirms it.
  BeaconPayload? _sending;

  /// The latest air pressure, sent along for the rescuers' coarse depth (none without a barometer).
  Hpa? _pressure;

  @override
  VictimState build() {
    final beacon = ref.watch(beaconPortProvider);
    final screen = ref.watch(screenAwakePortProvider);
    _id = ref.watch(beaconIdSourceProvider)();
    _liveness = Liveness(ref.read(clockProvider)());
    final timer = Timer.periodic(Liveness.quiet, (_) => unawaited(_tick()));
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

  List<StreamSubscription<Object?>> _listen(BeaconPort beacon) {
    ref.listen(appLifecycleProvider, (_, next) {
      // Back from Settings; a refusal that can still be asked is not asked again by itself.
      final settings = switch (state) {
        VictimNeedsPermission(:final permanently) => permanently,
        _ => false,
      };
      if (next.value == AppLifecycleState.resumed && settings) {
        unawaited(retry());
      }
    });
    return [
      beacon.advertiseStarted.listen((_) {
        if (_sending case final payload?) state = VictimCallingOut(payload);
      }),
      beacon.advertiseErrors.listen((message) {
        AppLogger.error('victim', 'Beacon stopped: $message');
        _fail();
      }),
      ref.watch(barometerPortProvider).pressures.listen((p) => _pressure = p),
      ref
          .watch(motionPortProvider)
          .accelerations
          .where((m) => m > movedAbove)
          .listen((_) => touched()),
      beacon.availabilityChanges.listen((availability) {
        if (onRadio(availability) case final next?) {
          _sending = null;
          state = next;
        } else if (availability == BluetoothAvailability.on &&
            state is! VictimCallingOut) {
          unawaited(retry());
        }
      }),
    ];
  }

  /// Starts (again) calling out.
  Future<void> retry() async {
    final beacon = ref.read(beaconPortProvider);
    final start = ref.read(startBeaconProvider);
    final payload = await _payload();
    _sending = payload;
    final BeaconStart result;
    try {
      result = await start(payload);
    } on Object catch (error, stack) {
      AppLogger.error('victim', 'Beacon did not start', error, stack);
      if (ref.mounted) _fail();
      return;
    }
    if (!ref.mounted) {
      // The screen closed while starting: leave no signal behind.
      if (result is BeaconStarted) unawaited(beacon.stopAdvertising());
      return;
    }
    if (result is! BeaconStarted) _sending = null;
    state = switch (result) {
      BeaconStarted() || BeaconNotReady() =>
        state is VictimCallingOut ? state : const VictimStarting(),
      BeaconNeedsPermission(:final permanently) => VictimNeedsPermission(
        permanently: permanently,
      ),
      BeaconBluetoothOff() => const VictimBluetoothOff(),
      BeaconUnsupported() => const VictimUnsupported(),
    };
  }

  /// The one action of the current state: Settings when only Settings can help, else start again.
  Future<void> act() => switch (state) {
    VictimNeedsPermission(permanently: true) =>
      ref.read(advertisePermissionProvider).openSettings(),
    _ => retry(),
  };

  /// Someone touched or moved the phone; after a quiet minute the signal says so at once.
  void touched() {
    if (_liveness.touch(ref.read(clockProvider)())) unawaited(_tick());
  }

  Future<void> _tick() async => switch (state) {
    VictimFailed() => retry(),
    VictimCallingOut() => _refresh(),
    _ => null,
  };

  Future<void> _refresh() async {
    final beacon = ref.read(beaconPortProvider);
    final payload = await _payload();
    _sending = payload;
    try {
      await beacon.advertise(payload);
    } on Object catch (error, stack) {
      AppLogger.error('victim', 'Beacon refresh failed', error, stack);
      if (ref.mounted) _fail();
    }
  }

  void _fail() {
    _sending = null;
    state = const VictimFailed();
  }

  /// Reads everything before the first await, so it is safe while the screen closes.
  Future<BeaconPayload> _payload() {
    final battery = ref.read(batteryProvider);
    final since = _liveness.since(ref.read(clockProvider)());
    final pressure = _pressure;
    return battery.level().then(
      (percent) => BeaconPayload(
        id: _id,
        batteryPercent: percent,
        sinceTouch: since,
        pressure: pressure,
      ),
    );
  }
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
    // Closed while the sound was starting: it must not outlive the screen.
    if (!ref.mounted) await sound.stop();
  }
}
