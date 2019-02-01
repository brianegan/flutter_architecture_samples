// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:fire_redux_sample/models/models.dart';
import 'package:todos_app_core/todos_app_core.dart';

List<Todo> todosSelector(AppState state) => state.todos;

VisibilityFilter activeFilterSelector(AppState state) => state.activeFilter;

AppTab activeTabSelector(AppState state) => state.activeTab;

bool isLoadingSelector(AppState state) => state.isLoading;

bool allCompleteSelector(List<Todo> todos) =>
    todos.every((todo) => todo.complete);

int numActiveSelector(List<Todo> todos) => activeTodosSelector(todos).length;

int numCompletedSelector(List<Todo> todos) =>
    completeTodosSelector(todos).length;

List<Todo> activeTodosSelector(List<Todo> todos) =>
    todos.where((todo) => !todo.complete).toList();

List<Todo> completeTodosSelector(List<Todo> todos) =>
    todos.where((todo) => todo.complete).toList();

List<Todo> filteredTodosSelector(
  List<Todo> todos,
  VisibilityFilter activeFilter,
) {
  switch (activeFilter) {
    case VisibilityFilter.active:
      return activeTodosSelector(todos);
    case VisibilityFilter.completed:
      return completeTodosSelector(todos);
    case VisibilityFilter.all:
    default:
      return todos;
  }
}

Optional<Todo> todoSelector(List<Todo> todos, String id) {
  try {
    return Optional.of(todos.firstWhere((todo) => todo.id == id));
  } catch (e) {
    return Optional.absent();
  }
}
