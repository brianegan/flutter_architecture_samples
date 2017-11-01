import 'package:flutter/foundation.dart';
import 'package:redux_sample/models.dart';

class ClearCompletedAction {
  @override
  String toString() {
    return 'ClearCompletedAction{}';
  }
}

class ToggleAllAction {
  @override
  String toString() {
    return 'ToggleAllAction{}';
  }
}

@immutable
class UpdateTodoAction {
  final String id;
  final Todo updatedTodo;

  UpdateTodoAction(this.id, this.updatedTodo);

  @override
  String toString() {
    return 'UpdateTodoAction{id: $id, todo: $updatedTodo}';
  }
}

@immutable
class DeleteTodoAction {
  final String id;

  DeleteTodoAction(this.id);

  @override
  String toString() {
    return 'DeleteTodoAction{id: $id}';
  }
}

@immutable
class AddTodoAction {
  final Todo todo;

  AddTodoAction(this.todo);

  @override
  String toString() {
    return 'AddTodoAction{todo: $todo}';
  }
}

@immutable
class UpdateFilterAction {
  final VisibilityFilter newFilter;

  UpdateFilterAction(this.newFilter);

  @override
  String toString() {
    return 'UpdateFilterAction{filter: $newFilter}';
  }
}

@immutable
class UpdateTabAction {
  final AppTab newTab;

  UpdateTabAction(this.newTab);

  @override
  String toString() {
    return 'UpdateTabAction{appTab: $newTab}';
  }
}
