// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:redux_sample/actions/actions.dart';
import 'package:redux_sample/models/models.dart';
import 'package:redux_sample/selectors/selectors.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:todos_repository_flutter/todos_repository_flutter.dart';

List<Middleware<AppState>> createStoreTodosMiddleware([
  TodosRepository repository = const TodosRepositoryFlutter(
    fileStorage: const FileStorage(
      '__redux_app__',
      getApplicationDocumentsDirectory,
    ),
  ),
]) {
  final saveTodos = _createSaveTodos(repository);
  final loadTodos = _createLoadTodos(repository);

  return [
    new TypedMiddleware<AppState, LoadTodosAction>(loadTodos),
    new TypedMiddleware<AppState, AddTodoAction>(saveTodos),
    new TypedMiddleware<AppState, ClearCompletedAction>(saveTodos),
    new TypedMiddleware<AppState, ToggleAllAction>(saveTodos),
    new TypedMiddleware<AppState, UpdateTodoAction>(saveTodos),
    new TypedMiddleware<AppState, TodosLoadedAction>(saveTodos),
    new TypedMiddleware<AppState, DeleteTodoAction>(saveTodos),
  ];
}

Middleware<AppState> _createSaveTodos(TodosRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);

    repository.saveTodos(
      todosSelector(store.state).map((todo) => todo.toEntity()).toList(),
    );
  };
}

Middleware<AppState> _createLoadTodos(TodosRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    repository.loadTodos().then(
      (todos) {
        store.dispatch(
          new TodosLoadedAction(
            todos.map(Todo.fromEntity).toList(),
          ),
        );
      },
    ).catchError((_) => store.dispatch(new TodosNotLoadedAction()));

    next(action);
  };
}
