import 'dart:async';

import 'package:beneathsos_app/core/models/ble_sample.dart';
import 'package:beneathsos_app/core/services/ble_service.dart';
import 'package:beneathsos_app/features/targets/presentation/providers/tracked_devices.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/samples.dart';

/// Wiring only — the tracking rules are covered by device_tracker_test.dart.
void main() {
  late StreamController<List<BleSample>> samples;
  late ProviderContainer container;

  setUp(() {
    samples = StreamController<List<BleSample>>();
    container = ProviderContainer(
      overrides: [bleSamplesProvider.overrideWith((ref) => samples.stream)],
    );
    // Riverpod 3 pauses unwatched providers; keep a listener like a screen would.
    container.listen(trackedDevicesProvider, (_, _) {});
  });

  tearDown(() async {
    container.dispose();
    await samples.close();
  });

  List<String> keys() => [
    for (final d in container.read(trackedDevicesProvider).devices) d.key,
  ];

  test('starts empty', () {
    expect(keys(), isEmpty);
  });

  test('sample batches from the scanner show up in the snapshot', () async {
    samples
      ..add([sample(key: 'A'), sample(key: 'B', at: 100)])
      ..add([sample(key: 'C', at: 200)]);
    await pumpEventQueue();

    expect(keys(), ['A', 'B', 'C']);
  });

  test('reset publishes an empty snapshot', () async {
    samples.add([sample(key: 'A')]);
    await pumpEventQueue();

    container.read(trackedDevicesProvider.notifier).reset();

    expect(keys(), isEmpty);
  });
}
