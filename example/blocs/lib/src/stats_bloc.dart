// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:blocs/src/models/models.dart';
import 'package:todos_repository/todos_repository.dart';

class StatsBloc {
  final Stream<int> numActive;
  final Stream<int> numComplete;

  StatsBloc._(
    this.numActive,
    this.numComplete,
  );

  factory StatsBloc(ReactiveTodosRepository repository) {
    final todos = repository
        .todos()
        .map((entities) => entities.map(Todo.fromEntity).toList());

    return new StatsBloc._(
      todos.map(_numActive),
      todos.map(_numComplete),
    );
  }

  static int _numActive(List<Todo> todos) {
    return todos.fold(0, (sum, todo) => !todo.complete ? ++sum : sum);
  }

  static int _numComplete(List<Todo> todos) {
    return todos.fold(0, (sum, todo) => todo.complete ? ++sum : sum);
  }
}
