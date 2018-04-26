// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:blocs/src/models/models.dart';
import 'package:blocs/src/todos_interactor.dart';

class StatsBloc {
  final TodosInteractor _interactor;

  StatsBloc(TodosInteractor interactor) : _interactor = interactor;

  Stream<int> get numActive => _interactor.todos.map(_numActive);

  Stream<int> get numComplete => _interactor.todos.map(_numComplete);

  static int _numActive(List<Todo> todos) {
    return todos.fold(0, (sum, todo) => !todo.complete ? ++sum : sum);
  }

  static int _numComplete(List<Todo> todos) {
    return todos.fold(0, (sum, todo) => todo.complete ? ++sum : sum);
  }
}
