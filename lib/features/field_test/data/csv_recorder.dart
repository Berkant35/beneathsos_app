import 'dart:io';

import 'package:beneathsos_app/core/models/ble_sample.dart';
import 'package:beneathsos_app/features/field_test/domain/device_kind.dart';
import 'package:path_provider/path_provider.dart';

/// Appends raw samples and markers to a CSV file. One instance per recording.
class CsvRecorder {
  CsvRecorder._(this.file, this._sink);

  /// Column header. Keep in sync with [_row]; analysis scripts depend on it.
  static const header =
      'wall_ms,mono_ns,key,rssi,company_id,kind,payload_hex,service_uuids,local_name,tx_power,is_target,marker';

  /// Output file.
  final File file;
  final IOSink _sink;

  /// Creates `recordings/field_<timestamp>.csv` in the app documents directory.
  static Future<CsvRecorder> create(DateTime now) async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/recordings');
    await dir.create(recursive: true);
    final stamp = now.toIso8601String().replaceAll(RegExp('[:.]'), '-');
    final file = File('${dir.path}/field_$stamp.csv');
    // Closed by close(); ownership moves to the returned recorder.
    // ignore: close_sinks
    final sink = file.openWrite()..writeln(header);
    return CsvRecorder._(file, sink);
  }

  /// Writes a batch of samples; [targets] marks rows of the selected targets.
  void writeSamples(List<BleSample> batch, Set<String> targets) {
    for (final s in batch) {
      _sink.writeln(_row(s, isTarget: targets.contains(s.key)));
    }
  }

  /// Writes a marker row (e.g. "P1 · 1 m · under concrete").
  void writeMarker(String text, int wallMillis) =>
      _sink.writeln('$wallMillis,,,,,,,,,,,${_escape(text)}');

  /// Flushes and closes the file.
  Future<void> close() async {
    await _sink.flush();
    await _sink.close();
  }

  static String _row(BleSample s, {required bool isTarget}) => [
    s.wallClockMillis,
    s.monotonicNanos,
    s.key,
    s.rssi,
    s.companyId ?? '',
    classify(s).name,
    _hex(s.payload),
    _escape(s.serviceUuids.join(' ')),
    _escape(s.localName ?? ''),
    s.txPower ?? '',
    if (isTarget) 1 else 0,
    '',
  ].join(',');

  static String _hex(List<int>? bytes) => bytes == null
      ? ''
      : bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

  static String _escape(String v) =>
      v.contains(RegExp('[,"\n]')) ? '"${v.replaceAll('"', '""')}"' : v;
}
