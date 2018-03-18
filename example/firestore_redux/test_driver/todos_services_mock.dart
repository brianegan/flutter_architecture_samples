// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:fire_redux_sample/models/models.dart';
import 'package:fire_redux_sample/todos_service.dart';
import 'package:todos_repository/src/web_client.dart';

class MockTodosServices implements TodosService {
  final controller = new StreamController<List<Todo>>(); // ignore: close_sinks
  List<Todo> todos;

  @override
  Future<void> addNewTodo(Todo newTodo) async {
    todos.add(newTodo);
    controller.add(todos);
  }

  @override
  Future<void> anonymousLogin([
    delayAuth = const Duration(milliseconds: 200),
  ]) {
    return new Future<void>.delayed(delayAuth);
  }

  @override
  Future<List<void>> deleteTodo(List<String> idList) async {
    todos.removeWhere((todo) => idList.contains(todo.id));
    controller.add(todos);

    return [];
  }

  @override
  Stream<List<Todo>> todosListener({webClient = const WebClient()}) async* {
    todos = (await webClient.fetchTodos()).map(Todo.fromEntity).toList();

    yield todos;

    await for (var latest in controller.stream) {
      yield latest;
    }
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    todos[todos.indexWhere((t) => t.id == todo.id)] = todo;

    controller.add(todos);
  }
}
