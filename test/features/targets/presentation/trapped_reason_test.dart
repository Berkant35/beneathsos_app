import 'dart:typed_data';

import 'package:beneathsos_app/core/beacon/domain/beacon_payload.dart';
import 'package:beneathsos_app/features/targets/domain/candidates.dart';
import 'package:beneathsos_app/features/targets/domain/device_kind.dart';
import 'package:beneathsos_app/features/targets/domain/device_tracker.dart';
import 'package:beneathsos_app/features/targets/presentation/mixins/targets_mixin.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/samples.dart';

class _Subject with TargetsMixin {}

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));
  final subject = _Subject();

  TargetCandidate trapped(List<int> data) {
    final tracker = DeviceTracker()
      ..ingest([
        sample(
          key: 'sos-0007',
          rssi: -60,
          serviceUuids: const [beaconServiceUuid],
          serviceData: {beaconServiceUuid: Uint8List.fromList(data)},
        ),
      ]);
    return rankCandidates(
      tracker.snapshot().devices,
      surface: const {},
      targets: const {},
    ).single;
  }

  test(
    'the card says the phone is trapped, with its battery and last touch',
    () {
      final candidate = trapped([1, 0, 7, 55, 3]);
      expect(candidate.device.kind, DeviceKind.trappedBeacon);
      expect(
        subject.kindLabel(l10n, candidate.device.kind),
        'BeneathSOS: “I am trapped”',
      );
      expect(
        subject.reason(l10n, candidate, surfaceScanned: false),
        startsWith(
          'This phone says it is trapped · battery 55 % · touched 3 min ago',
        ),
      );
    },
  );

  test('a long silence and an unknown battery are said plainly', () {
    expect(
      subject.reason(
        l10n,
        trapped([1, 0, 7, 0xff, 0xff]),
        surfaceScanned: false,
      ),
      startsWith(
        'This phone says it is trapped · not touched for over 4 hours',
      ),
    );
  });
}
