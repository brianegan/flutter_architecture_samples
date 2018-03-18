// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:fire_redux_sample/actions/actions.dart';
import 'package:fire_redux_sample/firestore_service.dart';
import 'package:fire_redux_sample/middleware/store_todos_middleware.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:fire_redux_sample/reducers/app_state_reducer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';

class MockFirestoreService extends Mock implements FirestoreService {}

class MockMiddleware extends Mock implements MiddlewareClass<AppState> {}

main() {
  group('Middleware Test', () {
    test('should log the user in and start listening for changes', () {
      final service = new MockFirestoreService();
      final captor = new MockMiddleware();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState.loading(),
        middleware: createStoreTodosMiddleware(service)..add(captor),
      );

      when(service.anonymousLogin()).thenReturn(new SynchronousFuture(null));
      when(service.todosListener()).thenReturn(new StreamController().stream);

      store.dispatch(new SignInAction());

      verify(service.anonymousLogin());
      verify(service.todosListener());
      verify(captor.call(
        any,
        new isInstanceOf<DataSourceConnectAction>(),
        any,
      ));
    });

    test('should send new todos to firestore', () {
      final todo = new Todo("T");
      final service = new MockFirestoreService();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState.loading(),
        middleware: createStoreTodosMiddleware(service),
      );

      store.dispatch(new AddTodoAction(todo));
      verify(service.addNewTodo(todo));
    });

    test('should clear the completed todos on firestore', () {
      final service = new MockFirestoreService();
      final todoA = new Todo("A");
      final todoB = new Todo("B", complete: true);
      final todoC = new Todo("C", complete: true);
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState(todos: [
          todoA,
          todoB,
          todoC,
        ]),
        middleware: createStoreTodosMiddleware(service),
      );

      store.dispatch(new ClearCompletedAction());

      verify(service.deleteTodo([todoB.id, todoC.id]));
    });

    test('should toggle all todos active on firestore', () {
      final service = new MockFirestoreService();
      final todoA = new Todo("A");
      final todoB = new Todo("B", complete: true);
      final todoC = new Todo("C", complete: true);
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState(todos: [
          todoA,
          todoB,
          todoC,
        ]),
        middleware: createStoreTodosMiddleware(service),
      );

      store.dispatch(new ToggleAllAction(true));

      verify(service.updateTodo(todoB.copyWith(complete: false)));
      verify(service.updateTodo(todoC.copyWith(complete: false)));
    });

    test('should toggle all todos complete on firestore', () {
      final service = new MockFirestoreService();
      final todoA = new Todo("A");
      final todoB = new Todo("B", complete: true);
      final todoC = new Todo("C", complete: true);
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState(todos: [
          todoA,
          todoB,
          todoC,
        ]),
        middleware: createStoreTodosMiddleware(service),
      );

      store.dispatch(new ToggleAllAction(false));

      verify(service.updateTodo(todoA.copyWith(complete: true)));
    });

    test('should update a todo on firestore', () {
      final service = new MockFirestoreService();
      final todo = new Todo("A");
      final update = todo.copyWith(task: "B");
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState(todos: [todo]),
        middleware: createStoreTodosMiddleware(service),
      );

      store.dispatch(new UpdateTodoAction(todo.id, update));

      verify(service.updateTodo(update));
    });

    test('shuld delete a todo on firestore', () {
      final service = new MockFirestoreService();
      final todo = new Todo("A");
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState(todos: [todo]),
        middleware: createStoreTodosMiddleware(service),
      );

      store.dispatch(new DeleteTodoAction(todo.id));

      verify(service.deleteTodo([todo.id]));
    });
  });
}
