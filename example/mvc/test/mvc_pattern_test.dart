import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:mvc_pattern/mvc_pattern.dart';

import 'counter_app_test.dart';

void main() {
  testWidgets('Header adds todo', (WidgetTester tester) async {
    // Use a key to locate the widget you need to test
    Key key = UniqueKey();

    // Tells the tester to build a UI based on the widget tree passed to it
    await tester.pumpWidget(MyApp(key: key));

    /// You can directly access the 'internal workings' of the app!
    MyApp _app = tester.widget(find.byKey(key));

    /// You've a reference to the Controller.
    Controller _con = _app.con;

    /// You've a reference to the StateView.
    StateMVC _state = _con.stateView;

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    /// You can access the Controller's properties.
    expect(_con.displayThis == 1, true);

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
