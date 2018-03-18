// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:fire_redux_sample/actions/actions.dart';
import 'package:fire_redux_sample/middleware/store_todos_middleware.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:fire_redux_sample/reducers/app_state_reducer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:todos_repository/todos_repository.dart';

class MockTodosService extends Mock implements TodosReactiveRepository {}

class MockMiddleware extends Mock implements MiddlewareClass<AppState> {}

main() {
  group('Middleware', () {
    test('should log in and start listening for changes', () {
      final service = new MockTodosService();
      final captor = new MockMiddleware();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState.loading(),
        middleware: createStoreTodosMiddleware(service)..add(captor),
      );

      when(service.anonymousLogin()).thenReturn(new SynchronousFuture(null));
      when(service.todos()).thenReturn(new StreamController().stream);

      store.dispatch(new InitAppAction());

      verify(service.anonymousLogin());
      verify(service.todos());
      verify(captor.call(
        any,
        new isInstanceOf<ConnectToDataSourceAction>(),
        any,
      ));
    });

    test('should send new todos to the service', () {
      final todo = new Todo("T");
      final service = new MockTodosService();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState.loading(),
        middleware: createStoreTodosMiddleware(service),
      );

      store.dispatch(new AddTodoAction(todo));
      verify(service.addNewTodo(todo.toEntity()));
    });

    test('should clear the completed todos from the service', () {
      final todoA = new Todo("A");
      final todoB = new Todo("B", complete: true);
      final todoC = new Todo("C", complete: true);
      final service = new MockTodosService();
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

    test('should inform the service to toggle all todos active', () {
      final todoA = new Todo("A", complete: true);
      final todoB = new Todo("B", complete: true);
      final service = new MockTodosService();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState(todos: [
          todoA,
          todoB,
        ]),
        middleware: createStoreTodosMiddleware(service),
      );

      store.dispatch(new ToggleAllAction());

      verify(service.updateTodo(todoA.copyWith(complete: false).toEntity()));
      verify(service.updateTodo(todoB.copyWith(complete: false).toEntity()));
    });

    test('should inform the service to toggle all todos complete', () {
      final todoA = new Todo("A");
      final todoB = new Todo("B", complete: true);
      final service = new MockTodosService();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState(todos: [
          todoA,
          todoB,
        ]),
        middleware: createStoreTodosMiddleware(service),
      );

      store.dispatch(new ToggleAllAction());

      verify(service.updateTodo(todoA.copyWith(complete: true).toEntity()));
    });

    test('should update a todo on firestore', () {
      final todo = new Todo("A");
      final update = todo.copyWith(task: "B");
      final service = new MockTodosService();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState(todos: [todo]),
        middleware: createStoreTodosMiddleware(service),
      );

      store.dispatch(new UpdateTodoAction(todo.id, update));

      verify(service.updateTodo(update.toEntity()));
    });

    test('should delete a todo on firestore', () {
      final todo = new Todo("A");
      final service = new MockTodosService();
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
