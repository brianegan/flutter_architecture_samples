// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:todos_app_core/todos_app_core.dart';
import 'package:redux_sample/models/models.dart';

List<Todo> todosSelector(AppState state) => state.todos;

VisibilityFilter activeFilterSelector(AppState state) => state.activeFilter;

AppTab activeTabSelector(AppState state) => state.activeTab;

bool isLoadingSelector(AppState state) => state.isLoading;

bool allCompleteSelector(List<Todo> todos) =>
    todos.every((todo) => todo.complete);

int numActiveSelector(List<Todo> todos) =>
    todos.fold(0, (sum, todo) => !todo.complete ? ++sum : sum);

int numCompletedSelector(List<Todo> todos) =>
    todos.fold(0, (sum, todo) => todo.complete ? ++sum : sum);

List<Todo> filteredTodosSelector(
  List<Todo> todos,
  VisibilityFilter activeFilter,
) {
  return todos.where((todo) {
    switch (activeFilter) {
      case VisibilityFilter.active:
        return !todo.complete;
      case VisibilityFilter.completed:
        return todo.complete;
      case VisibilityFilter.all:
      default:
        return true;
    }
  }).toList();
}

Optional<Todo> todoSelector(List<Todo> todos, String id) {
  try {
    return Optional.of(todos.firstWhere((todo) => todo.id == id));
  } catch (e) {
    return Optional.absent();
  }
}
