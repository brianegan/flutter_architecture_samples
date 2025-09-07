import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils.dart';
import 'test_screen.dart';

class AddTestScreen extends TestScreen {
  final _addScreenFinder = find.byKey(ValueKey('__addTodoScreen__'));
  final _backButtonFinder = find.byTooltip('Back');
  final _saveNewButtonFinder = find.byKey(ValueKey('__saveNewTodo__'));
  final _taskFieldFinder = find.byKey(ValueKey('__taskField__'));
  final _noteFieldFinder = find.byKey(ValueKey('__noteField__'));

  AddTestScreen(WidgetTester tester) : super(tester);

  @override
  Future<bool> isReady({Duration? timeout}) =>
      widgetExists(tester, _addScreenFinder);

  Future<AddTestScreen> tapBackButton() async {
    await tester.tap(_backButtonFinder);
    await tester.pumpAndSettle();

    return this;
  }

  Future<void> enterTask(String task) async {
    // must set focus to 'enable' keyboard even though focus already set
    await tester.tap(_taskFieldFinder);
    await tester.enterText(_taskFieldFinder, task);
    await tester.pumpAndSettle();
  }

  Future<void> enterNote(String note) async {
    // must set focus to 'enable' keyboard even though focus already set
    await tester.tap(_noteFieldFinder);
    await tester.enterText(_noteFieldFinder, note);
    await tester.pumpAndSettle();
  }

  Future<void> tapSaveNewButton() async {
    await tester.tap(_saveNewButtonFinder);
    await tester.pumpAndSettle();
  }
}
