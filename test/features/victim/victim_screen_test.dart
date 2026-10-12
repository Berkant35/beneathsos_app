import 'package:beneathsos_app/core/scanning/domain/scan_types.dart';
import 'package:beneathsos_app/features/home/presentation/screens/home_screen.dart';
import 'package:beneathsos_app/features/victim/presentation/screens/victim_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../core/beacon/fakes.dart';
import '../../core/scanning/fakes.dart';
import '../../helpers/pump_app.dart';

Future<BeaconFakes> _open(
  WidgetTester tester, {
  BeaconFakes? fakes,
  Locale locale = const Locale('en'),
}) async {
  final beacon = fakes ?? BeaconFakes();
  await pumpLocalized(
    tester,
    const VictimScreen(),
    locale: locale,
    beacon: beacon,
  );
  return beacon;
}

/// Moves the victim's clock and the fake timers by [minutes].
Future<void> _wait(WidgetTester tester, BeaconFakes fakes, int minutes) async {
  for (var i = 0; i < minutes; i++) {
    fakes.now = fakes.now.add(const Duration(minutes: 1));
    await tester.pump(const Duration(minutes: 1));
  }
}

void main() {
  testWidgets('opening the screen calls out at once, with a signal name', (
    tester,
  ) async {
    final fakes = await _open(tester);
    expect(fakes.beacon.sent, hasLength(1));
    expect(fakes.beacon.sent.single.id, 0x1a2b);
    expect(fakes.beacon.sent.single.batteryPercent, 80);
    expect(find.text('Your phone is calling out to rescuers.'), findsOneWidget);
    expect(find.text('Signal name: SOS-1A2B'), findsOneWidget);
    expect(find.text('Battery: 80 %'), findsOneWidget);
    expect(find.textContaining('call 112'), findsOneWidget);
  });

  testWidgets(
    'the signal tells rescuers how long since the phone was touched',
    (tester) async {
      final fakes = await _open(tester);
      await _wait(tester, fakes, 3);
      expect(fakes.beacon.sent.last.sinceTouch, const Duration(minutes: 3));
      await tester.tap(find.byType(VictimScreen));
      await tester.pump();
      expect(fakes.beacon.sent.last.sinceTouch, Duration.zero);
    },
  );

  testWidgets('Bluetooth off: says so, and calls out once it is turned on', (
    tester,
  ) async {
    final fakes = await _open(
      tester,
      fakes: BeaconFakes(
        beacon: FakeBeacon(availability: BluetoothAvailability.off),
      ),
    );
    expect(
      find.text('Turn on Bluetooth so rescuers can find this phone.'),
      findsOneWidget,
    );
    expect(fakes.beacon.sent, isEmpty);
    fakes.beacon.turn(BluetoothAvailability.on);
    await tester.pumpAndSettle();
    expect(fakes.beacon.sent, hasLength(1));
    expect(find.text('Your phone is calling out to rescuers.'), findsOneWidget);
  });

  testWidgets('a refused permission can be asked again', (tester) async {
    final permissions = FakePermissions(
      checkResult: ScanPermission.denied,
      requestResult: ScanPermission.denied,
    );
    final fakes = await _open(
      tester,
      fakes: BeaconFakes(permissions: permissions),
    );
    expect(
      find.text('Allow Bluetooth so rescuers can find this phone.'),
      findsOneWidget,
    );
    permissions.requestResult = ScanPermission.granted;
    await tester.tap(find.text('Allow Bluetooth'));
    await tester.pumpAndSettle();
    expect(fakes.beacon.sent, hasLength(1));
  });

  testWidgets('a permission only Settings can give opens Settings', (
    tester,
  ) async {
    final permissions = FakePermissions(
      checkResult: ScanPermission.permanentlyDenied,
    );
    await _open(tester, fakes: BeaconFakes(permissions: permissions));
    await tester.tap(find.text('Open Settings'));
    await tester.pump();
    expect(permissions.calls, contains('openSettings'));
  });

  testWidgets('a phone that cannot advertise still offers the SOS sound', (
    tester,
  ) async {
    final fakes = await _open(
      tester,
      fakes: BeaconFakes(beacon: FakeBeacon(canAdvertise: false)),
    );
    expect(
      find.text(
        'This phone cannot send a Bluetooth help signal. Use the SOS sound.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Play SOS sound'));
    await tester.pump();
    expect(fakes.sound.playing, isTrue);
    await tester.tap(find.text('Stop the SOS sound'));
    await tester.pump();
    expect(fakes.sound.playing, isFalse);
  });

  testWidgets('when the platform stops the signal, it says so and retries', (
    tester,
  ) async {
    final fakes = await _open(tester);
    fakes.beacon.fail('advertise failed: 4');
    await tester.pumpAndSettle();
    expect(find.text('The help signal stopped.'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(fakes.beacon.sent, hasLength(2));
    expect(find.text('Your phone is calling out to rescuers.'), findsOneWidget);
  });

  testWidgets('leaving asks first; Stop ends the signal and the sound', (
    tester,
  ) async {
    final fakes = BeaconFakes();
    await pumpRouterApp(tester, beacon: fakes);
    await tester.tap(find.text('I am trapped'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Play SOS sound'));
    await tester.pump();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Stop calling out?'), findsOneWidget);
    await tester.tap(find.text('Keep calling out'));
    await tester.pumpAndSettle();
    expect(find.byType(VictimScreen), findsOneWidget);
    expect(fakes.beacon.stopped, 0);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Stop'));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(fakes.beacon.stopped, greaterThan(0));
    expect(fakes.sound.playing, isFalse);
  });

  testWidgets('Turkish', (tester) async {
    await _open(tester, locale: const Locale('tr'));
    expect(find.text('Enkaz altındayım'), findsOneWidget);
    expect(find.textContaining("112'yi arayın"), findsOneWidget);
  });

  for (final (name, width, height) in [
    ('portrait', 375.0, 667.0),
    ('landscape', 667.0, 375.0),
  ]) {
    for (final (locale, needle) in [
      (const Locale('en'), 'call 112'),
      (const Locale('tr'), "112'yi arayın"),
    ]) {
      testWidgets(
        '200 % text, $name, ${locale.languageCode}: the 112 instruction is never cut off',
        (tester) async {
          setPhoneSize(tester, width, height);
          await pumpLocalizedScaled(
            tester,
            const VictimScreen(),
            locale: locale,
            textScale: 2,
            beacon: BeaconFakes(),
          );
          expect(tester.takeException(), isNull);
          await expectFullyReadable(tester, find.textContaining(needle));
        },
      );
    }
  }
}
