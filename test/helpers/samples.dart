import 'dart:typed_data';

import 'package:beneathsos_app/core/models/ble_sample.dart';

/// Builds a sample with sensible defaults.
BleSample sample({
  String key = 'AA',
  int rssi = -70,
  int at = 0,
  int? companyId,
  List<int>? payload,
  List<String> serviceUuids = const [],
  Map<String, Uint8List>? serviceData,
  String? localName,
}) => BleSample(
  key: key,
  rssi: rssi,
  serviceUuids: serviceUuids,
  serviceData: serviceData,
  localName: localName,
  monotonicNanos: at * 1000000,
  wallClockMillis: at,
  companyId: companyId,
  payload: payload == null ? null : Uint8List.fromList(payload),
);
