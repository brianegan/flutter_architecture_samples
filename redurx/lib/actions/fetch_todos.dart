import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:redurx_sample/data/todos_repository.dart';
import 'package:redurx_sample/models/app_state.dart';
import 'package:redurx_sample/models/todo.dart';

class FetchTodos implements AsyncAction<AppState> {
  TodosRepository _todosRepository;

  @override
  Future<Computation<AppState>> reduce(AppState state) async {
    assert(_todosRepository != null, 'TodosRepository not injected');

    final todos = await _todosRepository.loadTodos();

    return (AppState state) => state.rebuild((b) => b
      ..todos = BuiltList<Todo>.from(todos).toBuilder()
      ..isLoading = false);
  }

  void set todosRepository(TodosRepository todosRepository) {
    _todosRepository = todosRepository;
  }
}
