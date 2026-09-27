import 'package:beneathsos_app/features/field_test/domain/device_track.dart';
import 'package:beneathsos_app/features/field_test/presentation/providers/field_test_filter.dart';

/// Filtering and ordering of the device list.
mixin DeviceListMixin {
  /// Tracks passing [filter], targets first, then strongest latest RSSI.
  List<DeviceTrack> visibleTracks(
    Iterable<DeviceTrack> tracks,
    FieldTestFilterState filter,
    Set<String> targets,
  ) {
    final list =
        [
          for (final t in tracks)
            if (t.lastRssi >= filter.minRssi &&
                (!filter.appleOnly || t.kind.isApple) &&
                (!filter.targetsOnly || targets.contains(t.key)))
              t,
        ]..sort((a, b) {
          final byTarget =
              (targets.contains(b.key) ? 1 : 0) -
              (targets.contains(a.key) ? 1 : 0);
          return byTarget != 0 ? byTarget : b.lastRssi.compareTo(a.lastRssi);
        });
    return list;
  }
}
