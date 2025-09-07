import 'dart:async';

import 'package:blocs/src/models/models.dart';
import 'package:blocs/src/todos_interactor.dart';

class StatsBloc {
  final Stream<int> numActive;
  final Stream<int> numComplete;

  StatsBloc._(this.numActive, this.numComplete);

  factory StatsBloc(TodosInteractor interactor) {
    return StatsBloc._(
      interactor.todos.map(_numActive),
      interactor.todos.map(_numComplete),
    );
  }

  static int _numActive(List<Todo> todos) {
    return todos.fold(0, (sum, todo) => !todo.complete ? ++sum : sum);
  }

  static int _numComplete(List<Todo> todos) {
    return todos.fold(0, (sum, todo) => todo.complete ? ++sum : sum);
  }
}
