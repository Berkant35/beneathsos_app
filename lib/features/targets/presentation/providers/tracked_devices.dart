import 'dart:async';

import 'package:beneathsos_app/core/services/ble_service.dart';
import 'package:beneathsos_app/core/services/clock.dart';
import 'package:beneathsos_app/features/targets/domain/device_tracker.dart';
import 'package:beneathsos_app/features/targets/domain/tracker_snapshot.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tracked_devices.g.dart';

/// Everything the scanner has heard, as an immutable snapshot. Thin: feeds samples and the
/// clock into [DeviceTracker] (where the rules live) and publishes its snapshots.
@Riverpod(keepAlive: true)
class TrackedDevices extends _$TrackedDevices {
  /// How often silence rules are evaluated.
  static const tickInterval = Duration(seconds: 1);

  final _tracker = DeviceTracker();

  @override
  TrackerSnapshot build() {
    final samples = ref.listen(bleSamplesProvider, (_, next) {
      final batch = next.value;
      if (batch == null || batch.isEmpty) return;
      _tracker.ingest(batch);
      state = _tracker.snapshot();
    });
    final timer = Timer.periodic(tickInterval, (_) => _tick());
    ref.onDispose(() {
      samples.close();
      timer.cancel();
    });
    return _tracker.snapshot();
  }

  /// Forgets everything seen so far.
  void reset() {
    _tracker.reset();
    state = _tracker.snapshot();
  }

  void _tick() {
    final now = ref.read(clockProvider)().millisecondsSinceEpoch;
    if (_tracker.tick(now)) state = _tracker.snapshot();
  }
}
