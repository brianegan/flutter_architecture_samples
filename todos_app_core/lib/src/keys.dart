// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/widgets.dart';

class ArchSampleKeys {
  // Home Screens
  static const homeScreen = const Key('__homeScreen__');
  static const addTodoFab = const Key('__addTodoFab__');
  static const snackbar = const Key('__snackbar__');
  static Key snackbarAction(String id) => Key('__snackbar_action_${id}__');

  // Todos
  static const todoList = const Key('__todoList__');
  static const todosLoading = const Key('__todosLoading__');
  static final todoItem = (String id) => Key('TodoItem__${id}');
  static final todoItemCheckbox =
      (String id) => Key('TodoItem__${id}__Checkbox');
  static final todoItemTask = (String id) => Key('TodoItem__${id}__Task');
  static final todoItemNote = (String id) => Key('TodoItem__${id}__Note');

  // Tabs
  static const tabs = const Key('__tabs__');
  static const todoTab = const Key('__todoTab__');
  static const statsTab = const Key('__statsTab__');

  // Extra Actions
  static const extraActionsButton = const Key('__extraActionsButton__');
  static const toggleAll = const Key('__markAllDone__');
  static const clearCompleted = const Key('__clearCompleted__');

  // Filters
  static const filterButton = const Key('__filterButton__');
  static const allFilter = const Key('__allFilter__');
  static const activeFilter = const Key('__activeFilter__');
  static const completedFilter = const Key('__completedFilter__');

  // Stats
  static const statsCounter = const Key('__statsCounter__');
  static const statsLoading = const Key('__statsLoading__');
  static const statsNumActive = const Key('__statsActiveItems__');
  static const statsNumCompleted = const Key('__statsCompletedItems__');

  // Details Screen
  static const editTodoFab = const Key('__editTodoFab__');
  static const deleteTodoButton = const Key('__deleteTodoFab__');
  static const todoDetailsScreen = const Key('__todoDetailsScreen__');
  static final detailsTodoItemCheckbox = Key('DetailsTodo__Checkbox');
  static final detailsTodoItemTask = Key('DetailsTodo__Task');
  static final detailsTodoItemNote = Key('DetailsTodo__Note');

  // Add Screen
  static const addTodoScreen = const Key('__addTodoScreen__');
  static const saveNewTodo = const Key('__saveNewTodo__');
  static const taskField = const Key('__taskField__');
  static const noteField = const Key('__noteField__');

  // Edit Screen
  static const editTodoScreen = const Key('__editTodoScreen__');
  static const saveTodoFab = const Key('__saveTodoFab__');
}
