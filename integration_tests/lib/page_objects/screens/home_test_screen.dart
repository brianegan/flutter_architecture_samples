// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:integration_tests/page_objects/page_objects.dart';

import '../elements/extra_actions_element.dart';
import '../elements/filters_element.dart';
import '../elements/stats_element.dart';
import '../elements/todo_list_element.dart';
import '../utils.dart';
import 'test_screen.dart';

class HomeTestScreen extends TestScreen {
  final _filterButtonFinder = find.byValueKey('__filterButton__');
  final _extraActionsButtonFinder = find.byValueKey('__extraActionsButton__');
  final _todosTabFinder = find.byValueKey('__todoTab__');
  final _statsTabFinder = find.byValueKey('__statsTab__');
  final _snackbarFinder = find.byValueKey('__snackbar__');
  final _addTodoButtonFinder = find.byValueKey('__addTodoFab__');

  HomeTestScreen(FlutterDriver driver) : super(driver);

  @override
  Future<bool> isLoading({Duration timeout}) async =>
      TodoListElement(driver).isLoading;

  @override
  Future<bool> isReady({Duration timeout}) => TodoListElement(driver).isReady;

  TodoListElement get todoList {
    return TodoListElement(driver);
  }

  StatsElement get stats {
    return StatsElement(driver);
  }

  TodoListElement tapTodosTab() {
    driver.tap(_todosTabFinder);

    return TodoListElement(driver);
  }

  StatsElement tapStatsTab() {
    driver.tap(_statsTabFinder);

    return StatsElement(driver);
  }

  FiltersElement tapFilterButton() {
    driver.tap(_filterButtonFinder);

    return FiltersElement(driver);
  }

  ExtraActionsElement tapExtraActionsButton() {
    driver.tap(_extraActionsButtonFinder);

    return ExtraActionsElement(driver);
  }

  Future<bool> get snackbarVisible {
    return widgetExists(driver, _snackbarFinder);
  }

  AddTestScreen tapAddTodoButton() {
    driver.tap(_addTodoButtonFinder);

    return AddTestScreen(driver);
  }

  DetailsTestScreen tapTodo(String text) {
    driver.tap(find.text(text));
    return DetailsTestScreen(driver);
  }
}
