import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils.dart';
import 'edit_test_screen.dart';
import 'test_screen.dart';

class DetailsTestScreen extends TestScreen {
  final _detailsScreenFinder = find.byKey(ValueKey('__todoDetailsScreen__'));
  final _deleteButtonFinder = find.byKey(ValueKey('__deleteTodoFab__'));
  final _checkboxFinder = find.byKey(ValueKey('DetailsTodo__Checkbox'));
  final _taskFinder = find.byKey(ValueKey('DetailsTodo__Task'));
  final _noteFinder = find.byKey(ValueKey('DetailsTodo__Note'));
  final _editTodoFabFinder = find.byKey(ValueKey('__editTodoFab__'));
  final _backButtonFinder = find.byTooltip('Back');

  DetailsTestScreen(WidgetTester tester) : super(tester);

  @override
  Future<bool> isReady() async {
    await tester.pumpAndSettle();

    return widgetExists(tester, _detailsScreenFinder);
  }

  String get task => tester.widget<Text>(_taskFinder).data!;

  String get note => tester.widget<Text>(_noteFinder).data!;

  Future<DetailsTestScreen> tapCheckbox() async {
    await tester.tap(_checkboxFinder);
    await tester.pumpAndSettle();

    return this;
  }

  Future<EditTestScreen> tapEditTodoButton() async {
    await tester.tap(_editTodoFabFinder);
    await tester.pumpAndSettle();

    return EditTestScreen(tester);
  }

  Future<void> tapDeleteButton() async {
    await tester.tap(_deleteButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapBackButton() async {
    await tester.tap(_backButtonFinder);
    await tester.pumpAndSettle();
  }
}
