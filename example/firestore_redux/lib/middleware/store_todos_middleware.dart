// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:fire_redux_sample/actions/actions.dart';
import 'package:fire_redux_sample/firestore_service.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:fire_redux_sample/selectors/selectors.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createStoreTodosMiddleware(
  FirestoreService services,
) {
  return combineTypedMiddleware([
    new MiddlewareBinding<AppState, SignInAction>(
      _firestoreSignIn(services),
    ),
    new MiddlewareBinding<AppState, DataSourceConnectAction>(
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

TypedMiddleware<AppState, SignInAction> _firestoreSignIn(
  FirestoreService services,
) {
  return (store, SignInAction action, next) {
    next(action);

    services.anonymousLogin().then((_) {
      store.dispatch(new DataSourceConnectAction());
    });
  };
}

TypedMiddleware<AppState, DataSourceConnectAction> _firestoreConnect(
  FirestoreService services,
) {
  return (store, action, next) {
    next(action);

    services.todosListener().listen((todos) {
      store.dispatch(new LoadTodosAction(todos));
    });
  };
}

TypedMiddleware<AppState, AddTodoAction> _firestoreSaveNewTodo(
  FirestoreService services,
) {
  return (store, action, next) {
    next(action);
    services.addNewTodo(action.todo);
  };
}

TypedMiddleware<AppState, DeleteTodoAction> _firestoreDeleteTodo(
  FirestoreService services,
) {
  return (store, action, next) {
    next(action);
    services.deleteTodo([action.id]);
  };
}

TypedMiddleware<AppState, UpdateTodoAction> _firestoreUpdateTodo(
  FirestoreService services,
) {
  return (store, action, next) {
    next(action);
    services.updateTodo(action.updatedTodo);
  };
}

TypedMiddleware<AppState, ToggleAllAction> _firestoreToggleAll(
  FirestoreService services,
) {
  return (store, action, next) {
    for (var todo in todosSelector(store.state)) {
      if (action.toggleAllTodosToActive) {
        if (todo.complete) services.updateTodo(todo.copyWith(complete: false));
      } else {
        if (!todo.complete) services.updateTodo(todo.copyWith(complete: true));
      }
    }
    next(action);
  };
}

TypedMiddleware<AppState, ClearCompletedAction> _firestoreClearCompleted(
  FirestoreService services,
) {
  return (store, action, next) {
    next(action);

    services.deleteTodo(
      filteredTodosSelector(
        todosSelector(store.state),
        VisibilityFilter.completed,
      ).map((todo) => todo.id).toList(),
    );
  };
}
