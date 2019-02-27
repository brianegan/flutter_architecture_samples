// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:blocs/src/models/models.dart';
import 'package:blocs/src/todos_interactor.dart';

class TodoBloc {
  // Inputs
  final Sink<String> deleteTodo;
  final Sink<Todo> updateTodo;

  final TodosInteractor _interactor;
  final List<StreamSubscription<dynamic>> _subscriptions;

  TodoBloc._(
    this.deleteTodo,
    this.updateTodo,
    this._interactor,
    this._subscriptions,
  );

  factory TodoBloc(TodosInteractor interactor) {
    final removeTodoController = StreamController<String>(sync: true);
    final updateTodoController = StreamController<Todo>(sync: true);
    final subscriptions = <StreamSubscription<dynamic>>[
      // When a user updates an item, update the repository
      updateTodoController.stream.listen(interactor.updateTodo),

      // When a user removes an item, remove it from the repository
      removeTodoController.stream.listen(interactor.deleteTodo),
    ];

    return TodoBloc._(
      removeTodoController,
      updateTodoController,
      interactor,
      subscriptions,
    );
  }

  Stream<Todo> todo(String id) {
    return _interactor.todo(id);
  }

  void close() {
    deleteTodo.close();
    updateTodo.close();
    _subscriptions.forEach((subscription) => subscription.cancel());
  }
}
