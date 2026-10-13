import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:rubble_core/rubble_core.dart';

/// The service UUID of a BeneathSOS victim beacon (version 1).
const beaconServiceUuid = '06ad86ef-1e8c-47b4-9c65-c526d5e31581';

const _version = 1;
const _unknown = 0xff;

/// What a trapped phone sends: its beacon id (drawn once per victim-mode start, so it survives the
/// phone's address rotation), battery and how long since someone touched or moved it — a sign of life,
/// never a claim about the person — and, when the phone has a barometer, the air pressure there (the
/// rescuers' phones compare it with their own for a coarse depth, never from the signal: rule 2).
///
/// Android sends [encode] as service data; iOS can send only [localName].
@immutable
final class BeaconPayload {
  /// Creates a payload; [id] is 16 bits.
  const BeaconPayload({
    required this.id,
    required this.sinceTouch,
    this.batteryPercent,
    this.pressure,
  });

  /// Beacon id (0–0xFFFF).
  final int id;

  /// Battery level, or null when unknown.
  final int? batteryPercent;

  /// Time since the last touch or movement.
  final Duration sinceTouch;

  /// Air pressure at the phone, or null without a barometer.
  final Hpa? pressure;

  /// `SOS-1A2B`, or `SOS-1A2B-10132` with the pressure in tenths of a hPa.
  String get localName => [
    'SOS-${_hex(id).toUpperCase()}',
    if (_tenths case final tenths?) '$tenths',
  ].join('-');

  /// Version, id (big-endian), battery % (0xFF unknown), minutes since the last touch (0xFF = 255+),
  /// and — with a barometer — the pressure in tenths of a hPa (big-endian, 2 bytes).
  Uint8List encode() => Uint8List.fromList([
    _version,
    (id >> 8) & 0xff,
    id & 0xff,
    batteryPercent?.clamp(0, 100) ?? _unknown,
    sinceTouch.inMinutes.clamp(0, _unknown),
    if (_tenths case final tenths?) ...[(tenths >> 8) & 0xff, tenths & 0xff],
  ]);

  int? get _tenths => switch (pressure) {
    final p? => (p.value * 10).round().clamp(0, 0xfffe),
    null => null,
  };

  /// The payload in [bytes], or null when it is not a version 1 beacon.
  static BeaconPayload? decode(Uint8List bytes) {
    if (bytes.length < 5 || bytes[0] != _version) return null;
    return BeaconPayload(
      id: bytes[1] << 8 | bytes[2],
      batteryPercent: bytes[3] == _unknown ? null : bytes[3],
      sinceTouch: Duration(minutes: bytes[4]),
      pressure: bytes.length >= 7 ? Hpa((bytes[5] << 8 | bytes[6]) / 10) : null,
    );
  }
}

/// Whether an advert is a victim beacon (its UUID listed, or service data under it). UUIDs are
/// compared in any case (Android reports lower case, iOS upper case).
bool isBeacon({
  required List<String> serviceUuids,
  Map<String, Uint8List>? serviceData,
}) =>
    serviceUuids.any(_isBeacon) || (serviceData?.keys.any(_isBeacon) ?? false);

/// The tracking key of a victim beacon — `sos-1a2b` from its id (service data on Android, local name
/// on iOS) — or null when the advert carries no id or is not a beacon: then the platform key is used,
/// so two victims never merge into one track.
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
  final name = _name.firstMatch(localName ?? '');
  return name == null ? null : 'sos-${name[1]!.toLowerCase()}';
}

/// The pressure an iOS beacon gives in its name (`SOS-1A2B-10132`), or null.
Hpa? pressureFromName(String? localName) =>
    switch (_name.firstMatch(localName ?? '')?[2]) {
      final tenths? => Hpa(int.parse(tenths) / 10),
      null => null,
    };

final _name = RegExp(r'^SOS-([0-9A-F]{4})(?:-(\d{4,5}))?$');

bool _isBeacon(String uuid) => uuid.toLowerCase() == beaconServiceUuid;

String _hex(int id) => id.toRadixString(16).padLeft(4, '0');
