import 'package:beneathsos_app/core/services/ble_service.dart';
import 'package:beneathsos_app/core/services/clock.dart';
import 'package:beneathsos_app/features/targets/domain/presence_event.dart';
import 'package:beneathsos_app/features/targets/presentation/providers/device_table.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/samples.dart';

void main() {
  test('ingest builds tracks and logs identities appearing after warm-up', () {
    final container = ProviderContainer(
      overrides: [
        bleSamplesProvider.overrideWith((ref) => const Stream.empty()),
        clockProvider.overrideWithValue(
          () => DateTime.fromMillisecondsSinceEpoch(0),
        ),
      ],
    );
    addTearDown(container.dispose);
    final table = container.read(deviceTableProvider.notifier)
      ..ingest([sample(key: 'A'), sample(key: 'B', at: 1000)])
      ..ingest([sample(key: 'C', at: 8000)]);

    final state = container.read(deviceTableProvider);
    expect(state.tracks.keys, containsAll(['A', 'B', 'C']));
    expect(state.events.map((e) => (e.key, e.change)), [
      ('C', PresenceChange.appeared),
    ]);

    table.reset();
    expect(container.read(deviceTableProvider).tracks, isEmpty);
  });
}
