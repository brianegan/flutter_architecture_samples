// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:mvi_base/src/models/models.dart';
import 'package:todos_repository/todos_repository.dart';

class TodoBloc {
  final Sink<String> deleteTodo;
  final Sink<Todo> updateTodo;

  final ReactiveTodosRepository _repository;
  final List<Sink<dynamic>> _sinks;

  TodoBloc._(
    this.deleteTodo,
    this.updateTodo,
    this._repository,
    this._sinks,
  );

  factory TodoBloc(ReactiveTodosRepository repository) {
    final removeTodoController = new StreamController<String>(sync: true);
    final updateTodoController = new StreamController<Todo>(sync: true);

    // When a user updates an item, update the repository
    updateTodoController.stream
        .listen((todo) => repository.updateTodo(todo.toEntity()));

    // When a user removes an item, remove it from the repository
    removeTodoController.stream.listen((id) => repository.deleteTodo([id]));

    return new TodoBloc._(
      removeTodoController,
      updateTodoController,
      repository,
      [updateTodoController, removeTodoController],
    );
  }

  Stream<Todo> todo(String id) {
    return _repository
        .todos()
        .map((entities) => entities.firstWhere(
              (entity) => entity.id == id,
              orElse: () => null,
            ))
        .map((entity) => entity != null ? Todo.fromEntity(entity) : null);
  }

  void close() {
    _sinks.forEach((sink) => sink.close());
  }
}
