// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:simple_blocs/src/models/models.dart';
import 'package:simple_blocs/src/todos_interactor.dart';

class StatsBloc {
  final TodosInteractor _interactor;

  StatsBloc(TodosInteractor interactor) : _interactor = interactor;

  // Outputs
  Stream<int> get numActive => _interactor.todos.map((List<Todo> todos) =>
      todos.fold(0, (sum, todo) => !todo.complete ? ++sum : sum));

  Stream<int> get numComplete => _interactor.todos.map((List<Todo> todos) =>
      todos.fold(0, (sum, todo) => todo.complete ? ++sum : sum));
}
