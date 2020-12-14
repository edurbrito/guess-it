import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guess_it_app/screens/admin-code-page/admin-code-page.dart';
import 'package:guess_it_app/screens/admin-panel-page/admin-panel-page.dart';
import 'package:guess_it_app/screens/landing-page/landing-page.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  testWidgets('Button is present and triggers navigation after tapped', (WidgetTester tester) async {
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        home: LandingPanel(),
        navigatorObservers: [mockObserver],
      ),
    );

    expect(find.byType(FlatButton), findsOneWidget);
    await tester.tap(find.byType(FlatButton));
    await tester.pumpAndSettle();

    /// Verify that a push event happened
    verify(mockObserver.didPush(any, any));

    /// You'd also want to be sure that your page is now
    /// present in the screen.
    expect(find.byType(AdminCode), findsOneWidget);
  });

  testWidgets('Add a word to list', (WidgetTester tester) async {
    await tester.pumpWidget(AdminPanel());

    await tester.enterText(find.byKey(new Key('wordInput')), 'Hello');

    await tester.testTextInput.receiveAction(TextInputAction.done);

    await tester.pump();

    expect(find.text('Hello'), findsOneWidget);
  });
}