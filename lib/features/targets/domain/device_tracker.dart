import 'package:beneathsos_app/core/models/ble_sample.dart';
import 'package:beneathsos_app/features/targets/domain/device_track.dart';
import 'package:beneathsos_app/features/targets/domain/presence_event.dart';
import 'package:beneathsos_app/features/targets/domain/tracker_policy.dart';
import 'package:beneathsos_app/features/targets/domain/tracker_snapshot.dart';
import 'package:rubble_core/rubble_core.dart';

/// Turns raw samples into per-identity tracks and a presence log. Pure: no clock, no timers —
/// the caller passes the time to [tick].
final class DeviceTracker {
  /// Creates a tracker with [policy]. An identity must be logged "gone" before it can be
  /// forgotten, so `forgetAfter` has to be longer than `goneAfter`.
  DeviceTracker({this.policy = const TrackerPolicy()})
    : assert(
        policy.forgetAfter > policy.goneAfter,
        'forgetAfter must be longer than goneAfter',
      );

  /// Time rules.
  final TrackerPolicy policy;

  final _tracks = <String, DeviceTrack>{};
  final _events = <PresenceEvent>[];
  final _gone = <String>{};
  int? _startedMillis;

  /// Adds received samples. New identities after the warm-up are logged as "appeared".
  void ingest(List<BleSample> batch) {
    if (batch.isEmpty) return;
    final started = _startedMillis ??= batch.first.wallClockMillis;
    for (final sample in batch) {
      final track = _tracks[sample.key];
      if (track != null) {
        track.add(sample);
        _gone.remove(sample.key);
        continue;
      }
      _tracks[sample.key] = DeviceTrack.first(sample);
      if (sample.wallClockMillis - started > policy.warmUp.inMilliseconds) {
        _log(
          sample.key,
          PresenceChange.appeared,
          sample.wallClockMillis,
          sample.rssi,
        );
      }
    }
  }

  /// Applies the silence rules at [nowMillis]: logs "gone" once, forgets long-silent identities.
  /// Returns whether anything changed.
  bool tick(int nowMillis) {
    final forgotten = <String>[];
    var changed = false;
    for (final track in _tracks.values) {
      final silence = nowMillis - track.lastSeenMillis;
      if (!_gone.contains(track.key) &&
          silence > policy.goneAfter.inMilliseconds) {
        _gone.add(track.key);
        _log(track.key, PresenceChange.gone, nowMillis, track.lastRssi);
        changed = true;
      }
      if (silence > policy.forgetAfter.inMilliseconds) forgotten.add(track.key);
    }
    for (final key in forgotten) {
      _tracks.remove(key);
      _gone.remove(key);
    }
    return changed || forgotten.isNotEmpty;
  }

  /// An immutable copy of the current state.
  TrackerSnapshot snapshot() => TrackerSnapshot(
    devices: List.unmodifiable(_tracks.values.map(_summarize)),
    events: List.unmodifiable(_events),
    startedMillis: _startedMillis,
  );

  /// Forgets everything.
  void reset() {
    _tracks.clear();
    _events.clear();
    _gone.clear();
    _startedMillis = null;
  }

  void _log(String key, PresenceChange change, int atMillis, int rssi) {
    _events.add(
      PresenceEvent(key: key, change: change, atMillis: atMillis, rssi: rssi),
    );
    final overflow = _events.length - policy.maxEvents;
    if (overflow > 0) _events.removeRange(0, overflow);
  }

  /// The window of [DeviceSummary.median] and [DeviceSummary.spread].
  static const summaryWindow = Duration(seconds: 30);

  static DeviceSummary _summarize(DeviceTrack t) {
    final median = t.medianWithin(summaryWindow, t.lastSeenMillis);
    final spread = t.stdDevWithin(summaryWindow, t.lastSeenMillis);
    return DeviceSummary(
      key: t.key,
      kind: t.kind,
      lastRssi: t.lastRssi,
      firstSeenMillis: t.firstSeenMillis,
      lastSeenMillis: t.lastSeenMillis,
      sampleCount: t.sampleCount,
      median: median == null ? null : Dbm(median),
      spread: spread == null ? null : Decibels(spread),
    );
  }
}
