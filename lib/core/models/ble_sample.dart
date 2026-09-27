import 'dart:typed_data';

/// One received BLE advertisement, decoupled from the plugin types.
final class BleSample {
  /// Creates a sample.
  const BleSample({
    required this.key,
    required this.rssi,
    required this.serviceUuids,
    required this.monotonicNanos,
    required this.wallClockMillis,
    this.companyId,
    this.payload,
    this.localName,
    this.txPower,
  });

  /// Platform identity of the advertiser (rotates on phones, ~15 min).
  final String key;

  /// Received signal strength in dBm.
  final int rssi;

  /// Bluetooth SIG company identifier, if manufacturer data was present.
  final int? companyId;

  /// Manufacturer data without the company identifier.
  final Uint8List? payload;

  /// Advertised service UUIDs.
  final List<String> serviceUuids;

  /// Advertised local name.
  final String? localName;

  /// Advertised TX power level.
  final int? txPower;

  /// Monotonic receive time from the platform.
  final int monotonicNanos;

  /// Wall-clock receive time.
  final int wallClockMillis;
}
