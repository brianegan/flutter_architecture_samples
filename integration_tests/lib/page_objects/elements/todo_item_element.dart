import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../screens/details_test_screen.dart';
import '../utils.dart';
import 'test_element.dart';

class TodoItemElement extends TestElement {
  final String id;

  TodoItemElement(this.id, WidgetTester tester) : super(tester);

  Finder get _taskFinder => find.byKey(ValueKey('TodoItem__${id}__Task'));

  Finder get _checkboxFinder =>
      find.byKey(ValueKey('TodoItem__${id}__Checkbox'));

  Finder get _todoItemFinder => find.byKey(ValueKey('TodoItem__${id}'));

  Future<bool> get isVisible => widgetExists(tester, _todoItemFinder);

  Future<bool> get isAbsent => widgetAbsent(tester, _todoItemFinder);

  Future<String> get task async => tester.widget<Text>(_taskFinder).data!;

  Future<String> get note async =>
      tester.widget<Text>(find.byKey(ValueKey('TodoItem__${id}__Note'))).data!;

  Future<TodoItemElement> tapCheckbox() async {
    await tester.tap(_checkboxFinder);
    await tester.pumpAndSettle();

    return this;
  }

  Future<DetailsTestScreen> tap() async {
    await tester.tap(_taskFinder);
    await tester.pumpAndSettle();

    return DetailsTestScreen(tester);
  }
}
