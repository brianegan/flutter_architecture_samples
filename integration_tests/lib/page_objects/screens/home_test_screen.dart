import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_tests/page_objects/page_objects.dart';

import '../elements/extra_actions_element.dart';
import '../elements/filters_element.dart';
import '../elements/stats_element.dart';
import '../elements/todo_list_element.dart';
import '../utils.dart';
import 'test_screen.dart';

class HomeTestScreen extends TestScreen {
  final _filterButtonFinder = find.byKey(ValueKey('__filterButton__'));
  final _extraActionsButtonFinder =
      find.byKey(ValueKey('__extraActionsButton__'));
  final _todosTabFinder = find.byKey(ValueKey('__todoTab__'));
  final _statsTabFinder = find.byKey(ValueKey('__statsTab__'));
  final _snackbarFinder = find.byKey(ValueKey('__snackbar__'));
  final _addTodoButtonFinder = find.byKey(ValueKey('__addTodoFab__'));

  HomeTestScreen(WidgetTester tester) : super(tester);

  @override
  Future<bool> isLoading() async => TodoListElement(tester).isLoading;

  @override
  Future<bool> isReady() => TodoListElement(tester).isReady;

  TodoListElement get todoList {
    return TodoListElement(tester);
  }

  StatsElement get stats {
    return StatsElement(tester);
  }

  Future<TodoListElement> tapTodosTab() async {
    await tester.tap(_todosTabFinder);
    await tester.pumpAndSettle();

    return TodoListElement(tester);
  }

  Future<StatsElement> tapStatsTab() async {
    await tester.tap(_statsTabFinder);
    await tester.pumpAndSettle();

    return StatsElement(tester);
  }

  Future<FiltersElement> tapFilterButton() async {
    await tester.tap(_filterButtonFinder);
    await tester.pumpAndSettle();

    return FiltersElement(tester);
  }

  Future<ExtraActionsElement> tapExtraActionsButton() async {
    await tester.tap(_extraActionsButtonFinder);
    await tester.pumpAndSettle();

    return ExtraActionsElement(tester);
  }

  Future<bool> get snackbarVisible async {
    await tester.pumpAndSettle();
    return widgetExists(tester, _snackbarFinder);
  }

  Future<AddTestScreen> tapAddTodoButton() async {
    await tester.tap(_addTodoButtonFinder);
    await tester.pumpAndSettle();

    return AddTestScreen(tester);
  }

  Future<DetailsTestScreen> tapTodo(String text) async {
    await tester.tap(find.text(text));
    await tester.pumpAndSettle();

    return DetailsTestScreen(tester);
  }
}
