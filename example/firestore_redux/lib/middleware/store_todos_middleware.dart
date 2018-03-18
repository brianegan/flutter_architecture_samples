// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:fire_redux_sample/actions/actions.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:fire_redux_sample/selectors/selectors.dart';
import 'package:fire_redux_sample/todos_service.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createStoreTodosMiddleware(
  TodosService services,
) {
  return combineTypedMiddleware([
    new MiddlewareBinding<AppState, InitAppAction>(
      _firestoreSignIn(services),
    ),
    new MiddlewareBinding<AppState, ConnectToDataSourceAction>(
      _firestoreConnect(services),
    ),
    new MiddlewareBinding<AppState, AddTodoAction>(
      _firestoreSaveNewTodo(services),
    ),
    new MiddlewareBinding<AppState, DeleteTodoAction>(
      _firestoreDeleteTodo(services),
    ),
    new MiddlewareBinding<AppState, UpdateTodoAction>(
      _firestoreUpdateTodo(services),
    ),
    new MiddlewareBinding<AppState, ToggleAllAction>(
      _firestoreToggleAll(services),
    ),
    new MiddlewareBinding<AppState, ClearCompletedAction>(
      _firestoreClearCompleted(services),
    ),
  ]);
}

TypedMiddleware<AppState, InitAppAction> _firestoreSignIn(
  TodosService services,
) {
  return (store, InitAppAction action, next) {
    next(action);

    services.anonymousLogin().then((_) {
      store.dispatch(new ConnectToDataSourceAction());
    });
  };
}

TypedMiddleware<AppState, ConnectToDataSourceAction> _firestoreConnect(
  TodosService services,
) {
  return (store, action, next) {
    next(action);

    services.todosListener().listen((todos) {
      store.dispatch(new LoadTodosAction(todos));
    });
  };
}

TypedMiddleware<AppState, AddTodoAction> _firestoreSaveNewTodo(
  TodosService services,
) {
  return (store, action, next) {
    next(action);
    services.addNewTodo(action.todo);
  };
}

TypedMiddleware<AppState, DeleteTodoAction> _firestoreDeleteTodo(
  TodosService services,
) {
  return (store, action, next) {
    next(action);
    services.deleteTodo([action.id]);
  };
}

TypedMiddleware<AppState, UpdateTodoAction> _firestoreUpdateTodo(
  TodosService services,
) {
  return (store, action, next) {
    next(action);
    services.updateTodo(action.updatedTodo);
  };
}

TypedMiddleware<AppState, ToggleAllAction> _firestoreToggleAll(
  TodosService services,
) {
  return (store, action, next) {
    next(action);
    var todos = todosSelector(store.state);

    for (var todo in todos) {
      if (allCompleteSelector(todos)) {
        if (todo.complete) services.updateTodo(todo.copyWith(complete: false));
      } else {
        if (!todo.complete) services.updateTodo(todo.copyWith(complete: true));
      }
    }
  };
}

TypedMiddleware<AppState, ClearCompletedAction> _firestoreClearCompleted(
  TodosService services,
) {
  return (store, action, next) {
    next(action);

    services.deleteTodo(
      completeTodosSelector(todosSelector(store.state)).map((todo) => todo.id).toList(),
    );
  };
}
