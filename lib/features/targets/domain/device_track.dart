import 'dart:collection';
import 'dart:typed_data';

import 'package:beneathsos_app/core/beacon/domain/beacon_payload.dart';
import 'package:beneathsos_app/core/models/ble_sample.dart';
import 'package:beneathsos_app/features/targets/domain/device_kind.dart';
import 'package:beneathsos_app/features/targets/domain/rssi_point.dart';
import 'package:beneathsos_app/features/targets/domain/rssi_stats.dart';

/// Everything observed from one advertiser identity.
class DeviceTrack {
  /// Starts a track from its first [sample].
  DeviceTrack.first(BleSample sample)
    : key = sample.key,
      firstSeenMillis = sample.wallClockMillis,
      lastSeenMillis = sample.wallClockMillis,
      kind = classify(sample) {
    add(sample);
  }

  /// How many readings are kept (≈ 2 min at 10 Hz).
  static const int capacity = 1200;

  /// Platform identity.
  final String key;

  /// When this identity was first received.
  final int firstSeenMillis;

  /// When this identity was last received.
  int lastSeenMillis;

  /// Advertiser category.
  DeviceKind kind;

  /// Latest company identifier.
  int? companyId;

  /// Latest manufacturer payload.
  Uint8List? lastPayload;

  /// Latest advertised name.
  String? localName;

  /// Latest victim-beacon payload (Android victims send one).
  BeaconPayload? beacon;

  /// Total readings received.
  int sampleCount = 0;

  final Queue<RssiPoint> _window = Queue<RssiPoint>();

  /// Latest RSSI.
  int get lastRssi => _window.last.rssi;

  /// Readings in arrival order (oldest first).
  Iterable<RssiPoint> get readings => _window;

  /// Adds a reading of this identity.
  void add(BleSample sample) {
    lastSeenMillis = sample.wallClockMillis;
    sampleCount++;
    companyId = sample.companyId ?? companyId;
    lastPayload = sample.payload ?? lastPayload;
    localName = sample.localName ?? localName;
    final now = classify(sample);
    // A trapped beacon stays one; otherwise only an advert that tells something reclassifies.
    if (kind != DeviceKind.trappedBeacon && now != DeviceKind.unknown) {
      kind = now;
    }
    beacon =
        sample.serviceData?.entries
            .where((e) => e.key.toLowerCase() == beaconServiceUuid)
            .map((e) => BeaconPayload.decode(e.value))
            .nonNulls
            .firstOrNull ??
        beacon;
    _window.addLast((atMillis: sample.wallClockMillis, rssi: sample.rssi));
    if (_window.length > capacity) _window.removeFirst();
  }

  /// RSSI values received within [window] before [nowMillis].
  List<int> valuesWithin(Duration window, int nowMillis) {
    final from = nowMillis - window.inMilliseconds;
    return [
      for (final p in _window)
        if (p.atMillis >= from) p.rssi,
    ];
  }

  /// Median RSSI within [window].
  double? medianWithin(Duration window, int nowMillis) =>
      median(valuesWithin(window, nowMillis));

  /// Standard deviation within [window].
  double? stdDevWithin(Duration window, int nowMillis) =>
      standardDeviation(valuesWithin(window, nowMillis));

  /// Readings per second over the last [window].
  double rateWithin(Duration window, int nowMillis) =>
      valuesWithin(window, nowMillis).length / (window.inMilliseconds / 1000);
}
