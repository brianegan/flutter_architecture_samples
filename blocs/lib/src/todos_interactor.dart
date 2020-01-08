// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:blocs/blocs.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

class TodosInteractor {
  final ReactiveTodosRepository repository;

  TodosInteractor(this.repository);

  Stream<List<Todo>> get todos {
    return repository.todos().map((entities) {
      return entities.map(Todo.fromEntity).toList();
    });
  }

  Stream<Todo> todo(String id) {
    return todos.map((todos) {
      return todos.firstWhere(
        (todo) => todo.id == id,
        orElse: () => null,
      );
    }).where((todo) => todo != null);
  }

  Stream<bool> get allComplete => todos.map(_allComplete);

  Stream<bool> get hasCompletedTodos => todos.map(_hasCompletedTodos);

  Future<void> updateTodo(Todo todo) => repository.updateTodo(todo.toEntity());

  Future<void> addNewTodo(Todo todo) => repository.addNewTodo(todo.toEntity());

  Future<void> deleteTodo(String id) => repository.deleteTodo([id]);

  Future<void> clearCompleted([_]) async =>
      repository.deleteTodo(await todos.map(_completedTodoIds).first);

  Future<List<dynamic>> toggleAll([_]) async {
    final updates = await todos.map(_todosToUpdate).first;

    return Future.wait(
        updates.map((update) => repository.updateTodo(update.toEntity())));
  }

  static bool _hasCompletedTodos(List<Todo> todos) {
    return todos.any((todo) => todo.complete);
  }

  static List<String> _completedTodoIds(List<Todo> todos) {
    return todos.fold<List<String>>([], (prev, todo) {
      if (todo.complete) {
        return prev..add(todo.id);
      } else {
        return prev;
      }
    });
  }

  static List<Todo> _todosToUpdate(List<Todo> todos) {
    final allComplete = _allComplete(todos);

    return todos.fold<List<Todo>>([], (prev, todo) {
      if (allComplete) {
        return prev..add(todo.copyWith(complete: false));
      } else if (!allComplete && !todo.complete) {
        return prev..add(todo.copyWith(complete: true));
      } else {
        return prev;
      }
    });
  }

  static bool _allComplete(List<Todo> todos) =>
      todos.every((todo) => todo.complete);
}
