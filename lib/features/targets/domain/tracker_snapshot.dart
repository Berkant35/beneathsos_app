import 'package:beneathsos_app/features/targets/domain/device_kind.dart';
import 'package:beneathsos_app/features/targets/domain/presence_event.dart';

/// Immutable view of one advertiser at snapshot time.
final class DeviceSummary {
  /// Creates a summary.
  const DeviceSummary({
    required this.key,
    required this.kind,
    required this.lastRssi,
    required this.firstSeenMillis,
    required this.lastSeenMillis,
    required this.sampleCount,
  });

  /// Platform identity (rotates on phones).
  final String key;

  /// Advertiser category.
  final DeviceKind kind;

  /// Latest RSSI in dBm.
  final int lastRssi;

  /// When this identity was first heard.
  final int firstSeenMillis;

  /// When this identity was last heard.
  final int lastSeenMillis;

  /// Readings received so far.
  final int sampleCount;
}

/// Immutable view of everything the tracker knows.
final class TrackerSnapshot {
  /// Creates a snapshot.
  const TrackerSnapshot({
    required this.devices,
    required this.events,
    required this.startedMillis,
  });

  /// Nothing seen yet.
  const TrackerSnapshot.empty()
    : devices = const [],
      events = const [],
      startedMillis = null;

  /// Identities currently tracked (not yet forgotten), in first-seen order.
  final List<DeviceSummary> devices;

  /// Appeared / gone log, oldest first.
  final List<PresenceEvent> events;

  /// When the first sample arrived.
  final int? startedMillis;
}
