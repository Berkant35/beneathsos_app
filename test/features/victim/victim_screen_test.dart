import 'package:beneathsos_app/features/victim/presentation/screens/victim_screen.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('English: never an empty screen — tells the user to call 112', (
    tester,
  ) async {
    await pumpLocalized(tester, const VictimScreen());
    expect(find.text('I am trapped'), findsOneWidget);
    expect(find.textContaining('call 112'), findsOneWidget);
  });

  testWidgets('Turkish', (tester) async {
    await pumpLocalized(
      tester,
      const VictimScreen(),
      locale: const Locale('tr'),
    );
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
          );
          await expectFullyReadable(tester, find.textContaining(needle));
        },
      );
    }
  }

  testWidgets('Turkish: the 112 instruction sits in a "Hazırlanıyor" card', (
    tester,
  ) async {
    await pumpLocalized(
      tester,
      const VictimScreen(),
      locale: const Locale('tr'),
    );
    expect(find.byType(BeneathCard), findsOneWidget);
    expect(find.text('Hazırlanıyor'), findsOneWidget);
  });
}
