import 'package:beneathsos_app/features/sites/presentation/screens/new_site_screen.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('English: title and what comes next', (tester) async {
    await pumpLocalized(tester, const NewSiteScreen());
    expect(find.text('New search'), findsOneWidget);
    expect(
      find.textContaining('draw the outline of the rubble site'),
      findsOneWidget,
    );
  });

  testWidgets('Turkish', (tester) async {
    await pumpLocalized(
      tester,
      const NewSiteScreen(),
      locale: const Locale('tr'),
    );
    expect(find.text('Yeni arama'), findsOneWidget);
    expect(find.textContaining('enkaz alanının sınırlarını'), findsOneWidget);
  });

  testWidgets(
    '200 % text on a small phone: the whole explanation is readable',
    (tester) async {
      setPhoneSize(tester, 375, 667);
      await pumpLocalizedScaled(tester, const NewSiteScreen(), textScale: 2);
      await expectFullyReadable(tester, find.textContaining('rubble site'));
    },
  );

  testWidgets('the explanation sits in a "Being prepared" card', (
    tester,
  ) async {
    await pumpLocalized(tester, const NewSiteScreen());
    expect(find.byType(BeneathCard), findsOneWidget);
    expect(find.text('Being prepared'), findsOneWidget);
    expect(find.byIcon(Icons.construction_rounded), findsOneWidget);
  });
}
