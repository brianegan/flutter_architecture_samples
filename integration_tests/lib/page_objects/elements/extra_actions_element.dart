import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_element.dart';

class ExtraActionsElement extends TestElement {
  final _toggleAll = find.byKey(ValueKey('__markAllDone__'));
  final _clearCompleted = find.byKey(ValueKey('__clearCompleted__'));

  ExtraActionsElement(WidgetTester tester) : super(tester);

  Future<ExtraActionsElement> tapToggleAll() async {
    await tester.tap(_toggleAll);
    await tester.pumpAndSettle();

    return this;
  }

  Future<ExtraActionsElement> tapClearCompleted() async {
    await tester.tap(_clearCompleted);
    await tester.pumpAndSettle();

    return this;
  }
}
