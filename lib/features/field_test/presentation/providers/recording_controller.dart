import 'dart:async';
import 'dart:io';

import 'package:beneathsos_app/core/models/ble_sample.dart';
import 'package:beneathsos_app/core/services/ble_service.dart';
import 'package:beneathsos_app/core/services/clock.dart';
import 'package:beneathsos_app/features/field_test/data/csv_recorder.dart';
import 'package:beneathsos_app/features/field_test/presentation/providers/target_selection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

part 'recording_controller.g.dart';

/// Recording lifecycle.
sealed class RecordingState {
  const RecordingState({this.lastFile});

  /// The most recent finished recording, if any.
  final File? lastFile;
}

/// Not recording.
final class RecordingOff extends RecordingState {
  /// Creates the state.
  const RecordingOff({super.lastFile});
}

/// Writing samples to [file].
final class RecordingOn extends RecordingState {
  /// Creates the state.
  const RecordingOn({
    required this.file,
    required this.since,
    required this.samples,
    super.lastFile,
  });

  /// Output file.
  final File file;

  /// Start time.
  final DateTime since;

  /// Samples written so far.
  final int samples;
}

/// Records raw samples and markers to CSV for offline analysis.
@Riverpod(keepAlive: true)
class RecordingController extends _$RecordingController {
  CsvRecorder? _recorder;

  @override
  RecordingState build() {
    final sub = ref.listen(bleSamplesProvider, (_, next) {
      final batch = next.value;
      if (batch != null) _write(batch);
    });
    ref.onDispose(() {
      sub.close();
      unawaited(_recorder?.close());
    });
    return const RecordingOff();
  }

  /// Starts a new file.
  Future<void> start() async {
    if (state is RecordingOn) return;
    final now = ref.read(clockProvider)();
    _recorder = await CsvRecorder.create(now);
    state = RecordingOn(
      file: _recorder!.file,
      since: now,
      samples: 0,
      lastFile: state.lastFile,
    );
  }

  /// Closes the file.
  Future<void> stop() async {
    final recorder = _recorder;
    if (recorder == null) return;
    _recorder = null;
    await recorder.close();
    state = RecordingOff(lastFile: recorder.file);
  }

  /// Writes a marker row.
  void addMarker(String text) => _recorder?.writeMarker(
    text,
    ref.read(clockProvider)().millisecondsSinceEpoch,
  );

  /// Opens the share sheet for the last finished file.
  Future<void> shareLast() async {
    final file = state.lastFile;
    if (file == null) return;
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  }

  void _write(List<BleSample> batch) {
    final recorder = _recorder;
    final current = state;
    if (recorder == null || current is! RecordingOn) return;
    recorder.writeSamples(batch, ref.read(targetSelectionProvider));
    state = RecordingOn(
      file: current.file,
      since: current.since,
      samples: current.samples + batch.length,
      lastFile: current.lastFile,
    );
  }
}
