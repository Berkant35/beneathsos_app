import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:beneathsos_app/core/beacon/domain/beacon_ports.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sos_sound_service.g.dart';

/// Plays `assets/sounds/sos.wav` (SOS at 3 kHz, `tools/make_sos_sound.py`) in a loop at full
/// volume, also with the ring switch on silent (audioplayers' default playback category on iOS).
/// Implements [SosSoundPort].
class SosSoundService implements SosSoundPort {
  final _player = AudioPlayer();

  @override
  Future<void> play() async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(1);
    await _player.play(AssetSource('sounds/sos.wav'));
  }

  @override
  Future<void> stop() => _player.stop();

  /// Releases the player.
  Future<void> dispose() => _player.dispose();
}

/// App-wide SOS sound.
@Riverpod(keepAlive: true)
SosSoundPort sosSound(Ref ref) {
  final service = SosSoundService();
  ref.onDispose(() => unawaited(service.dispose()));
  return service;
}
