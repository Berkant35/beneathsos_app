import 'dart:typed_data';

import 'package:meta/meta.dart';

/// The service UUID of a BeneathSOS victim beacon (version 1).
const beaconServiceUuid = '06ad86ef-1e8c-47b4-9c65-c526d5e31581';

const _version = 1;
const _unknown = 0xff;

/// What a trapped phone sends: its beacon id (drawn once per victim-mode start, so it survives the
/// phone's address rotation), battery and how long since someone touched or moved it — a sign of life,
/// never a claim about the person.
///
/// Android sends [encode] as service data; iOS can send only [localName].
@immutable
final class BeaconPayload {
  /// Creates a payload; [id] is 16 bits.
  const BeaconPayload({
    required this.id,
    required this.sinceTouch,
    this.batteryPercent,
  });

  /// Beacon id (0–0xFFFF).
  final int id;

  /// Battery level, or null when unknown.
  final int? batteryPercent;

  /// Time since the last touch or movement.
  final Duration sinceTouch;

  /// `SOS-1A2B`.
  String get localName => 'SOS-${_hex(id).toUpperCase()}';

  /// Version, id (big-endian), battery % (0xFF unknown), minutes since the last touch (0xFF = 255+).
  Uint8List encode() => Uint8List.fromList([
    _version,
    (id >> 8) & 0xff,
    id & 0xff,
    batteryPercent?.clamp(0, 100) ?? _unknown,
    sinceTouch.inMinutes.clamp(0, _unknown),
  ]);

  /// The payload in [bytes], or null when it is not a version 1 beacon.
  static BeaconPayload? decode(Uint8List bytes) {
    if (bytes.length < 5 || bytes[0] != _version) return null;
    return BeaconPayload(
      id: bytes[1] << 8 | bytes[2],
      batteryPercent: bytes[3] == _unknown ? null : bytes[3],
      sinceTouch: Duration(minutes: bytes[4]),
    );
  }
}

/// The tracking key of a victim beacon — `sos-1a2b` from its id (service data on Android, local name
/// on iOS), `sos-unknown` when it carries none — or null when the advert is not a beacon. UUIDs are
/// compared in any case (Android reports lower case, iOS upper case).
String? beaconKey({
  required List<String> serviceUuids,
  Map<String, Uint8List>? serviceData,
  String? localName,
}) {
  final data = serviceData?.entries
      .where((e) => _isBeacon(e.key))
      .map((e) => BeaconPayload.decode(e.value))
      .nonNulls
      .firstOrNull;
  if (data != null) return 'sos-${_hex(data.id)}';
  if (!serviceUuids.any(_isBeacon)) return null;
  final name = RegExp(r'^SOS-([0-9A-F]{4})$').firstMatch(localName ?? '');
  return name == null ? 'sos-unknown' : 'sos-${name[1]!.toLowerCase()}';
}

bool _isBeacon(String uuid) => uuid.toLowerCase() == beaconServiceUuid;

String _hex(int id) => id.toRadixString(16).padLeft(4, '0');
