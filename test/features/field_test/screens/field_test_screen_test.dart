import 'package:beneathsos_app/core/services/ble_service.dart';
import 'package:beneathsos_app/core/services/clock.dart';
import 'package:beneathsos_app/features/field_test/presentation/providers/device_table.dart';
import 'package:beneathsos_app/features/field_test/presentation/screens/field_test_screen.dart';
import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/samples.dart';

class _FakeBleService extends Mock implements BleService {}

void main() {
  testWidgets('lists devices strongest first with their kind', (tester) async {
    final ble = _FakeBleService();
    when(() => ble.errors).thenAnswer((_) => const Stream.empty());
    when(() => ble.availabilityChanges).thenAnswer((_) => const Stream.empty());
    final container = ProviderContainer(
      overrides: [
        bleServiceProvider.overrideWithValue(ble),
        bleSamplesProvider.overrideWith((ref) => const Stream.empty()),
        clockProvider.overrideWithValue(
          () => DateTime.fromMillisecondsSinceEpoch(1000),
        ),
        secondTickerProvider.overrideWith((ref) => const Stream.empty()),
      ],
    );
    container.read(deviceTableProvider.notifier).ingest([
      sample(key: 'WEAK-DEVICE-1', rssi: -88, at: 900),
      sample(
        key: 'FINDMY-DEVICE',
        rssi: -61,
        at: 950,
        companyId: 0x004C,
        payload: [0x12],
      ),
    ]);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: FieldTestScreen(),
        ),
      ),
    );
    await tester.pump();

    final titles = tester
        .widgetList<ListTile>(find.byType(ListTile))
        .map((t) => (t.title! as Text).data!)
        .toList();
    expect(titles.first, contains('Apple · Find My'));
    expect(titles.last, contains('DEVICE-1'));
    expect(find.text('Start scan'), findsOneWidget);

    // Dispose inside the test so the table's periodic timer is cancelled before invariants run.
    await tester.pumpWidget(const SizedBox());
    container.dispose();
  });
}
