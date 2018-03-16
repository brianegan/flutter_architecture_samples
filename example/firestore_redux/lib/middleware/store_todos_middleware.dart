// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:fire_redux_sample/actions/actions.dart';
import 'package:fire_redux_sample/firestore_services.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:fire_redux_sample/selectors/selectors.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createStoreTodosMiddleware(
    FirestoreServices firestoreServices) {
  return combineTypedMiddleware([
    new MiddlewareBinding<AppState, AddTodoAction>(
        _firestoreSaveNewTodo(firestoreServices)),
    new MiddlewareBinding<AppState, DeleteTodoAction>(
        _firestoreDeleteTodo(firestoreServices)),
    new MiddlewareBinding<AppState, UpdateTodoAction>(
        _firestoreUpdateTodo(firestoreServices)),
    new MiddlewareBinding<AppState, ToggleAllAction>(
        _firestoreToggleAll(firestoreServices)),
    new MiddlewareBinding<AppState, ClearCompletedAction>(
        _firestoreClearCompleted(firestoreServices)),
  ]);
}

Middleware<AppState> _firestoreSaveNewTodo(
    FirestoreServices firestoreServices) {
  return (Store<AppState> store, action, NextDispatcher next) {
    firestoreServices.addNewTodo(store, action.todo);
    next(action);
  };
}

Middleware<AppState> _firestoreDeleteTodo(FirestoreServices firestoreServices) {
  return (Store<AppState> store, action, NextDispatcher next) {
    firestoreServices.deleteTodo(store, [action.id]);
    next(action);
  };
}

Middleware<AppState> _firestoreUpdateTodo(FirestoreServices firestoreServices) {
  return (Store<AppState> store, action, NextDispatcher next) {
    firestoreServices.updateTodo(store, action.updatedTodo);
    next(action);
  };
}

Middleware<AppState> _firestoreToggleAll(FirestoreServices firestoreServices) {
  return (Store<AppState> store, action, NextDispatcher next) {
    for (var todo in todosSelector(store.state)) {
      if (action.toggleAllTodosToActive) {
        if (todo.complete)
          firestoreServices.updateTodo(store, todo.copyWith(complete: false));
      } else {
        if (!todo.complete)
          firestoreServices.updateTodo(store, todo.copyWith(complete: true));
      }
    }
    next(action);
  };
}

Middleware<AppState> _firestoreClearCompleted(
    FirestoreServices firestoreServices) {
  return (Store<AppState> store, action, NextDispatcher next) {
    List<String> indexesToDelete = [];
    for (var todo in todosSelector(store.state)) {
      if (todo.complete) indexesToDelete.add(todo.id);
    }
    firestoreServices.deleteTodo(store, indexesToDelete);
    next(action);
  };
}
