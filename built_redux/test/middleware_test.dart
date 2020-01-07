// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:built_redux/built_redux.dart';
import 'package:built_redux_sample/actions/actions.dart';
import 'package:built_redux_sample/data/todos_repository.dart';
import 'package:built_redux_sample/middleware/store_todos_middleware.dart';
import 'package:built_redux_sample/models/models.dart';
import 'package:built_redux_sample/reducers/reducers.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

/// We create two Mocks for our Web Service and File Storage. We will use these
/// mock classes to verify the behavior of the TodosService.
class MockTodosService extends Mock implements TodosRepository {}

void main() {
  group('TodosMiddleware', () {
    test(
        'should load todos when the app dispatches a fetch action and the app is loading',
        () {
      final service = MockTodosService();
      final middleware = createStoreTodosMiddleware(service);
      final store = Store<AppState, AppStateBuilder, AppActions>(
        reducerBuilder.build(),
        AppState.loading(),
        AppActions(),
        middleware: [middleware],
      );
      final todos = [Todo('Task')];

      // We'll use our mock throughout the tests to set certain conditions. In
      // this first test, we want to mock out our file storage to return a
      // list of Todos that we define here in our test!
      when(service.loadTodos()).thenAnswer((_) => Future.value(todos));

      store.actions.fetchTodosAction();

      verify(service.loadTodos());
    });

    test(
        'should not load todos when the app dispatches a fetch action and the app is not loading',
        () {
      final service = MockTodosService();
      final middleware = createStoreTodosMiddleware(service);
      final store = Store<AppState, AppStateBuilder, AppActions>(
        reducerBuilder.build(),
        AppState(),
        AppActions(),
        middleware: [middleware],
      );
      final todos = [Todo('Task')];

      // We'll use our mock throughout the tests to set certain conditions. In
      // this first test, we want to mock out our file storage to return a
      // list of Todos that we define here in our test!
      when(service.loadTodos()).thenAnswer((_) => Future.value(todos));

      store.actions.fetchTodosAction();

      verifyNever(service.loadTodos());
    });

    test('should save todos on all action that update the todo', () {
      final service = MockTodosService();
      final middleware = createStoreTodosMiddleware(service);
      final store = Store<AppState, AppStateBuilder, AppActions>(
        reducerBuilder.build(),
        AppState(),
        AppActions(),
        middleware: [middleware],
      );
      final todos = [Todo('Task')];

      when(service.saveTodos(todos)).thenAnswer((_) => Future.value(todos));

      // Dispatch all actions that update our Todos. We expect each to
      // trigger a call to our Storage Service.
      store.actions.addTodoAction(Todo('Wat'));
      store.actions.clearCompletedAction();
      store.actions.deleteTodoAction('');
      store.actions.toggleAllAction();
      store.actions.updateTodoAction(UpdateTodoActionPayload(
        '',
        Todo('Update'),
      ));

      verify(service.saveTodos(any)).called(5);
    });
  });
}
