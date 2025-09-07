import 'dart:async';

import 'package:simple_blocs/src/models/models.dart';
import 'package:simple_blocs/src/todos_interactor.dart';

class StatsBloc {
  final TodosInteractor _interactor;

  StatsBloc(TodosInteractor interactor) : _interactor = interactor;

  // Outputs
  Stream<int> get numActive => _interactor.todos.map(
    (List<Todo> todos) =>
        todos.fold(0, (sum, todo) => !todo.complete ? ++sum : sum),
  );

  Stream<int> get numComplete => _interactor.todos.map(
    (List<Todo> todos) =>
        todos.fold(0, (sum, todo) => todo.complete ? ++sum : sum),
  );
}
