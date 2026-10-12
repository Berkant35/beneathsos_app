import 'package:beneathsos_app/features/victim/presentation/screens/victim_screen.dart';
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
}
