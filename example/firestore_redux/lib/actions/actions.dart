// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:fire_redux_sample/models/models.dart';

class ClearCompletedAction {}

class ToggleAllAction {
  final bool toggleAllTodosToActive;

  ToggleAllAction(this.toggleAllTodosToActive);

  @override
  String toString() {
    return 'ToggleAllAction{toggleAllTodosToActive: $toggleAllTodosToActive}';
  }
}

class LoadTodosAction {
  final List<Todo> todos;

  LoadTodosAction(this.todos);

  @override
  String toString() {
    return 'LoadTodosAction{todos: $todos}';
  }
}

class UpdateTodoAction {
  final String id;
  final Todo updatedTodo;

  UpdateTodoAction(this.id, this.updatedTodo);

  @override
  String toString() {
    return 'UpdateTodoAction{id: $id, updatedTodo: $updatedTodo}';
  }
}

class DeleteTodoAction {
  final String id;

  DeleteTodoAction(this.id);

  @override
  String toString() {
    return 'DeleteTodoAction{id: $id}';
  }
}

class AddTodoAction {
  final Todo todo;

  AddTodoAction(this.todo);

  @override
  String toString() {
    return 'AddTodoAction{todo: $todo}';
  }
}

class SignInAction {}

class DataSourceConnectAction {}

class UpdateFilterAction {
  final VisibilityFilter newFilter;

  UpdateFilterAction(this.newFilter);

  @override
  String toString() {
    return 'UpdateFilterAction{newFilter: $newFilter}';
  }
}

class UpdateTabAction {
  final AppTab newTab;

  UpdateTabAction(this.newTab);

  @override
  String toString() {
    return 'UpdateTabAction{newTab: $newTab}';
  }
}
