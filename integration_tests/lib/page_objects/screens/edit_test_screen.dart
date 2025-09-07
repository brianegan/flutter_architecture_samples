import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils.dart';
import 'test_screen.dart';

class EditTestScreen extends TestScreen {
  final _editScreenFinder = find.byKey(ValueKey('__editTodoScreen__'));
  final _backButtonFinder = find.byTooltip('Back');
  final _taskFieldFinder = find.byKey(ValueKey('__taskField__'));
  final _noteFieldFinder = find.byKey(ValueKey('__noteField__'));
  final _saveFabFinder = find.byKey(ValueKey('__saveTodoFab__'));

  EditTestScreen(WidgetTester tester) : super(tester);

  @override
  Future<bool> isReady() async {
    await tester.pumpAndSettle();

    return widgetExists(tester, _editScreenFinder);
  }

  Future<void> tapBackButton() async {
    await tester.tap(_backButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<Null> editTask(String task) async {
    // must set focus to 'enable' keyboard even though focus already set
    await tester.tap(_taskFieldFinder);
    await tester.enterText(_taskFieldFinder, task);
    await tester.pumpAndSettle();
  }

  Future<Null> editNote(String note) async {
    // must set focus to 'enable' keyboard even though focus already set
    await tester.tap(_noteFieldFinder);
    await tester.enterText(_noteFieldFinder, note);
    await tester.pumpAndSettle();
  }

  Future<Null> tapSaveFab() async {
    await tester.tap(_saveFabFinder);
  }
}
