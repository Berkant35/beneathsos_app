import 'dart:async';

import 'package:beneathsos_app/core/models/ble_sample.dart';
import 'package:beneathsos_app/core/services/ble_service.dart';
import 'package:beneathsos_app/core/services/clock.dart';
import 'package:beneathsos_app/features/field_test/domain/device_track.dart';
import 'package:beneathsos_app/features/field_test/domain/presence_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_table.g.dart';

/// Snapshot of everything the scanner has seen. [version] changes on every update so widgets
/// rebuild even though tracks are mutated in place (performance: hundreds of samples/s).
final class DeviceTableState {
  /// Creates a snapshot.
  const DeviceTableState({
    required this.tracks,
    required this.events,
    required this.version,
    required this.startedMillis,
  });

  /// Empty table.
  const DeviceTableState.empty()
    : tracks = const {},
      events = const [],
      version = 0,
      startedMillis = null;

  /// Tracks by identity.
  final Map<String, DeviceTrack> tracks;

  /// Appeared / gone log, oldest first.
  final List<PresenceEvent> events;

  /// Increments on each change.
  final int version;

  /// When the first sample arrived.
  final int? startedMillis;
}

/// Aggregates samples into tracks and logs identity changes.
@Riverpod(keepAlive: true)
class DeviceTable extends _$DeviceTable {
  final _tracks = <String, DeviceTrack>{};
  final _events = <PresenceEvent>[];
  final _gone = <String>{};
  int? _started;

  @override
  DeviceTableState build() {
    final sub = ref.listen(bleSamplesProvider, (_, next) {
      final batch = next.value;
      if (batch != null && batch.isNotEmpty) ingest(batch);
    });
    final timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _checkGone(),
    );
    ref.onDispose(() {
      sub.close();
      timer.cancel();
    });
    return const DeviceTableState.empty();
  }

  /// Adds a batch of samples (public for tests).
  void ingest(List<BleSample> batch) {
    _started ??= batch.first.wallClockMillis;
    for (final s in batch) {
      final track = _tracks[s.key];
      if (track == null) {
        _tracks[s.key] = DeviceTrack.first(s);
        if (s.wallClockMillis - _started! >
            PresencePolicy.warmUp.inMilliseconds) {
          _events.add(
            PresenceEvent(
              key: s.key,
              change: PresenceChange.appeared,
              atMillis: s.wallClockMillis,
              rssi: s.rssi,
            ),
          );
        }
      } else {
        track.add(s);
        _gone.remove(s.key);
      }
    }
    _emit();
  }

  /// Clears everything.
  void reset() {
    _tracks.clear();
    _events.clear();
    _gone.clear();
    _started = null;
    state = const DeviceTableState.empty();
  }

  void _checkGone() {
    final now = ref.read(clockProvider)().millisecondsSinceEpoch;
    var changed = false;
    for (final t in _tracks.values) {
      if (_gone.contains(t.key)) continue;
      if (now - t.lastSeenMillis > PresencePolicy.goneAfter.inMilliseconds) {
        _gone.add(t.key);
        _events.add(
          PresenceEvent(
            key: t.key,
            change: PresenceChange.gone,
            atMillis: now,
            rssi: t.lastRssi,
          ),
        );
        changed = true;
      }
    }
    if (changed) _emit();
  }

  void _emit() => state = DeviceTableState(
    tracks: Map.unmodifiable(_tracks),
    events: List.unmodifiable(_events),
    version: state.version + 1,
    startedMillis: _started,
  );
}
