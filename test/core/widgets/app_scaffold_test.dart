import 'package:beneathsos_app/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('without a title there is no app bar', (tester) async {
    await pumpLocalized(tester, const AppScaffold(body: Text('body')));
    expect(find.byType(AppBar), findsNothing);
    expect(find.text('body'), findsOneWidget);
  });

  testWidgets('with a title the app bar shows it', (tester) async {
    await pumpLocalized(
      tester,
      const AppScaffold(title: 'Title', body: Text('body')),
    );
    expect(find.widgetWithText(AppBar, 'Title'), findsOneWidget);
  });
}
