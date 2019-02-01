// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:simple_blocs/src/models/models.dart';
import 'package:simple_blocs/src/todos_interactor.dart';

class TodoBloc {
  final TodosInteractor _interactor;

  TodoBloc(TodosInteractor interactor) : _interactor = interactor;

  // Inputs
  void deleteTodo(String id) => _interactor.deleteTodo(id);

  void updateTodo(Todo todo) => _interactor.updateTodo(todo);

  // Outputs
  Stream<Todo> todo(String id) => _interactor.todo(id);
}
