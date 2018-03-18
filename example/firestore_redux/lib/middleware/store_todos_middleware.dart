// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:fire_redux_sample/actions/actions.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:fire_redux_sample/selectors/selectors.dart';
import 'package:redux/redux.dart';
import 'package:todos_repository/todos_repository.dart';

List<Middleware<AppState>> createStoreTodosMiddleware(
  TodosReactiveRepository repository,
) {
  return combineTypedMiddleware([
    new MiddlewareBinding<AppState, InitAppAction>(
      _firestoreSignIn(repository),
    ),
    new MiddlewareBinding<AppState, ConnectToDataSourceAction>(
      _firestoreConnect(repository),
    ),
    new MiddlewareBinding<AppState, AddTodoAction>(
      _firestoreSaveNewTodo(repository),
    ),
    new MiddlewareBinding<AppState, DeleteTodoAction>(
      _firestoreDeleteTodo(repository),
    ),
    new MiddlewareBinding<AppState, UpdateTodoAction>(
      _firestoreUpdateTodo(repository),
    ),
    new MiddlewareBinding<AppState, ToggleAllAction>(
      _firestoreToggleAll(repository),
    ),
    new MiddlewareBinding<AppState, ClearCompletedAction>(
      _firestoreClearCompleted(repository),
    ),
  ]);
}

TypedMiddleware<AppState, InitAppAction> _firestoreSignIn(
  TodosReactiveRepository repository,
) {
  return (store, InitAppAction action, next) {
    next(action);

    repository.anonymousLogin().then((_) {
      store.dispatch(new ConnectToDataSourceAction());
    });
  };
}

TypedMiddleware<AppState, ConnectToDataSourceAction> _firestoreConnect(
  TodosReactiveRepository repository,
) {
  return (store, action, next) {
    next(action);

    repository.todos().listen((todos) {
      store.dispatch(new LoadTodosAction(todos.map(Todo.fromEntity).toList()));
    });
  };
}

TypedMiddleware<AppState, AddTodoAction> _firestoreSaveNewTodo(
  TodosReactiveRepository repository,
) {
  return (store, action, next) {
    next(action);
    repository.addNewTodo(action.todo.toEntity());
  };
}

TypedMiddleware<AppState, DeleteTodoAction> _firestoreDeleteTodo(
  TodosReactiveRepository repository,
) {
  return (store, action, next) {
    next(action);
    repository.deleteTodo([action.id]);
  };
}

TypedMiddleware<AppState, UpdateTodoAction> _firestoreUpdateTodo(
  TodosReactiveRepository repository,
) {
  return (store, action, next) {
    next(action);
    repository.updateTodo(action.updatedTodo.toEntity());
  };
}

TypedMiddleware<AppState, ToggleAllAction> _firestoreToggleAll(
  TodosReactiveRepository repository,
) {
  return (store, action, next) {
    next(action);
    var todos = todosSelector(store.state);

    for (var todo in todos) {
      if (allCompleteSelector(todos)) {
        if (todo.complete)
          repository.updateTodo(todo.copyWith(complete: false).toEntity());
      } else {
        if (!todo.complete)
          repository.updateTodo(todo.copyWith(complete: true).toEntity());
      }
    }
  };
}

TypedMiddleware<AppState, ClearCompletedAction> _firestoreClearCompleted(
  TodosReactiveRepository repository,
) {
  return (store, action, next) {
    next(action);

    repository.deleteTodo(
      completeTodosSelector(todosSelector(store.state))
          .map((todo) => todo.id)
          .toList(),
    );
  };
}
