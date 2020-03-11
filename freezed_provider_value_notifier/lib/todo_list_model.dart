// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:freezed_provider_value_notifier/models.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

part 'todo_list_model.freezed.dart';

enum VisibilityFilter { all, active, completed }

@freezed
abstract class TodoList with _$TodoList {
  factory TodoList(
    List<Todo> todos, {
    @required VisibilityFilter filter,
    @required bool loading,
  }) = TodoListState;

  @late
  int get numCompleted =>
      todos.where((Todo todo) => todo.complete).toList().length;

  @late
  bool get hasCompleted => numCompleted > 0;

  @late
  int get numActive =>
      todos.where((Todo todo) => !todo.complete).toList().length;

  @late
  bool get hasActiveTodos => numActive > 0;

  @late
  List<Todo> get filteredTodos => todos.where((todo) {
        switch (filter) {
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

extension TodoById on TodoList {
  Todo todoById(String id) =>
      todos.firstWhere((it) => it.id == id, orElse: () => null);
}

class TodoListController extends ValueNotifier<TodoList> {
  TodoListController({
    VisibilityFilter filter = VisibilityFilter.all,
    @required this.todosRepository,
    List<Todo> todos = const [],
  })  : assert(todosRepository != null),
        super(TodoList(todos, filter: filter, loading: false)) {
    _loadTodos();
  }

  final TodosRepository todosRepository;

  set filter(VisibilityFilter filter) {
    value = value.copyWith(filter: filter);
  }

  @override
  @protected
  set value(TodoList state) {
    if (!const DeepCollectionEquality().equals(state.todos, value.todos)) {
      todosRepository
          .saveTodos(state.todos.map((it) => it.toEntity()).toList());
    }
    super.value = state;
  }

  Future<void> _loadTodos() async {
    value = (value.copyWith(loading: true));

    try {
      final todos = await todosRepository.loadTodos();
      value = (value.copyWith(
          todos: todos.map(Todo.fromEntity).toList(), loading: false));
    } catch (_) {
      value = (value.copyWith(loading: false));
    }
  }

  void addTodo(Todo todo) {
    value = value.copyWith(todos: [...value.todos, todo]);
  }

  void updateTodo(Todo updatedTodo) {
    value = value.copyWith(todos: [
      for (final todo in value.todos)
        if (todo.id == updatedTodo.id) updatedTodo else todo,
    ]);
  }

  void removeTodoWithId(String id) {
    value = value.copyWith(todos: [
      for (final todo in value.todos) if (todo.id != id) todo,
    ]);
  }

  void toggleAll() {
    final allComplete = value.todos.every((todo) => todo.complete);
    value = value.copyWith(todos: [
      for (final todo in value.todos) todo.copy(complete: !allComplete),
    ]);
  }

  void clearCompleted() {
    value = value.copyWith(
      todos: value.todos.where((todo) => !todo.complete).toList(),
    );
  }
}
