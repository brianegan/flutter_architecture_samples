// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:todos_app_core/todos_app_core.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

class AppState {
  bool isLoading;
  List<Todo> todos;

  AppState({
    this.isLoading = false,
    this.todos = const [],
  });

  factory AppState.loading() => AppState(isLoading: true);

  bool get allComplete => todos.every((todo) => todo.complete);

  List<Todo> filteredTodos(VisibilityFilter activeFilter) =>
      todos.where((todo) {
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

  bool get hasCompletedTodos => todos.any((todo) => todo.complete);

  @override
  int get hashCode => todos.hashCode ^ isLoading.hashCode;

  int get numActive =>
      todos.fold(0, (sum, todo) => !todo.complete ? ++sum : sum);

  int get numCompleted =>
      todos.fold(0, (sum, todo) => todo.complete ? ++sum : sum);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          todos == other.todos &&
          isLoading == other.isLoading;

  void clearCompleted() {
    todos.removeWhere((todo) => todo.complete);
  }

  void toggleAll() {
    final allCompleted = allComplete;

    todos.forEach((todo) => todo.complete = !allCompleted);
  }

  @override
  String toString() {
    return 'AppState{todos: $todos, isLoading: $isLoading}';
  }
}

enum AppTab { todos, stats }

enum ExtraAction { toggleAllComplete, clearCompleted }

class Todo {
  bool complete;
  String id;
  String note;
  String task;

  Todo(this.task, {this.complete = false, this.note = '', String id})
      : id = id ?? Uuid().generateV4();

  @override
  int get hashCode =>
      complete.hashCode ^ task.hashCode ^ note.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Todo &&
          runtimeType == other.runtimeType &&
          complete == other.complete &&
          task == other.task &&
          note == other.note &&
          id == other.id;

  @override
  String toString() {
    return 'Todo{complete: $complete, task: $task, note: $note, id: $id}';
  }

  TodoEntity toEntity() {
    return TodoEntity(task, id, note, complete);
  }

  static Todo fromEntity(TodoEntity entity) {
    return Todo(
      entity.task,
      complete: entity.complete ?? false,
      note: entity.note,
      id: entity.id ?? Uuid().generateV4(),
    );
  }
}

enum VisibilityFilter { all, active, completed }
