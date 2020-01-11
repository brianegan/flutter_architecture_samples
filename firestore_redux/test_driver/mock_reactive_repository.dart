// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:todos_repository_core/todos_repository_core.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

class MockUserRepository implements UserRepository {
  @override
  Future<UserEntity> login([
    delayAuth = const Duration(milliseconds: 200),
  ]) {
    return Future<UserEntity>.delayed(delayAuth);
  }
}

class MockReactiveTodosRepository implements ReactiveTodosRepository {
  // ignore: close_sinks
  final controller = StreamController<List<TodoEntity>>();
  List<TodoEntity> _todos = [];

  @override
  Future<void> addNewTodo(TodoEntity newTodo) async {
    _todos.add(newTodo);
    controller.add(_todos);
  }

  @override
  Future<List<void>> deleteTodo(List<String> idList) async {
    _todos.removeWhere((todo) => idList.contains(todo.id));
    controller.add(_todos);

    return [];
  }

  @override
  Stream<List<TodoEntity>> todos({webClient = const WebClient()}) async* {
    _todos = await webClient.loadTodos();

    yield _todos;

    await for (var latest in controller.stream) {
      yield latest;
    }
  }

  @override
  Future<void> updateTodo(TodoEntity todo) async {
    _todos[_todos.indexWhere((t) => t.id == todo.id)] = todo;

    controller.add(_todos);
  }
}
