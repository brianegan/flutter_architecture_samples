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

class MockReactiveTodosRepository extends Mock
    implements ReactiveTodosRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockMiddleware extends Mock implements MiddlewareClass<AppState> {}

main() {
  group('Middleware', () {
    test('should log in and start listening for changes', () {
      final todosRepository = new MockReactiveTodosRepository();
      final userRepository = new MockUserRepository();
      final captor = new MockMiddleware();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState.loading(),
        middleware: createStoreTodosMiddleware(todosRepository, userRepository)
          ..add(captor),
      );

      when(userRepository.login()).thenReturn(new SynchronousFuture(null));
      when(todosRepository.todos()).thenReturn(new StreamController().stream);

      store.dispatch(new InitAppAction());

      verify(userRepository.login());
      verify(todosRepository.todos());
      verify(captor.call(
        any,
        new isInstanceOf<ConnectToDataSourceAction>(),
        any,
      ));
    });

    test('should convert entities to todos', () async {
      // ignore: close_sinks
      final controller = new StreamController(sync: true);
      final todo = new Todo('A');
      final todosRepository = new MockReactiveTodosRepository();
      final userRepository = new MockUserRepository();
      final captor = new MockMiddleware();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState.loading(),
        middleware: createStoreTodosMiddleware(todosRepository, userRepository)
          ..add(captor),
      );

      when(todosRepository.todos()).thenReturn(controller.stream);

      store.dispatch(new ConnectToDataSourceAction());
      controller.add([todo.toEntity()]);

      verify(captor.call(
        any,
        new isInstanceOf<LoadTodosAction>(),
        any,
      ));
    });

    test('should send new todos to the repository', () {
      final todo = new Todo("T");
      final todosRepository = new MockReactiveTodosRepository();
      final userRepository = new MockUserRepository();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState.loading(),
        middleware: createStoreTodosMiddleware(todosRepository, userRepository),
      );

      store.dispatch(new AddTodoAction(todo));
      verify(todosRepository.addNewTodo(todo.toEntity()));
    });

    test('should clear the completed todos from the repository', () {
      final todoA = new Todo("A");
      final todoB = new Todo("B", complete: true);
      final todoC = new Todo("C", complete: true);
      final todosRepository = new MockReactiveTodosRepository();
      final userRepository = new MockUserRepository();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState(todos: [
          todoA,
          todoB,
          todoC,
        ]),
        middleware: createStoreTodosMiddleware(todosRepository, userRepository),
      );

      store.dispatch(new ClearCompletedAction());

      verify(todosRepository.deleteTodo([todoB.id, todoC.id]));
    });

    test('should inform the repository to toggle all todos active', () {
      final todoA = new Todo("A", complete: true);
      final todoB = new Todo("B", complete: true);
      final todosRepository = new MockReactiveTodosRepository();
      final userRepository = new MockUserRepository();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState(todos: [
          todoA,
          todoB,
        ]),
        middleware: createStoreTodosMiddleware(todosRepository, userRepository),
      );

      store.dispatch(new ToggleAllAction());

      verify(todosRepository.updateTodo(todoA.copyWith(complete: false).toEntity()));
      verify(todosRepository.updateTodo(todoB.copyWith(complete: false).toEntity()));
    });

    test('should inform the repository to toggle all todos complete', () {
      final todoA = new Todo("A");
      final todoB = new Todo("B", complete: true);
      final todosRepository = new MockReactiveTodosRepository();
      final userRepository = new MockUserRepository();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState(todos: [
          todoA,
          todoB,
        ]),
        middleware: createStoreTodosMiddleware(todosRepository, userRepository),
      );

      store.dispatch(new ToggleAllAction());

      verify(todosRepository.updateTodo(todoA.copyWith(complete: true).toEntity()));
    });

    test('should update a todo on firestore', () {
      final todo = new Todo("A");
      final update = todo.copyWith(task: "B");
      final todosRepository = new MockReactiveTodosRepository();
      final userRepository = new MockUserRepository();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState(todos: [todo]),
        middleware: createStoreTodosMiddleware(todosRepository, userRepository),
      );

      store.dispatch(new UpdateTodoAction(todo.id, update));

      verify(todosRepository.updateTodo(update.toEntity()));
    });

    test('should delete a todo on firestore', () {
      final todo = new Todo("A");
      final todosRepository = new MockReactiveTodosRepository();
      final userRepository = new MockUserRepository();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState(todos: [todo]),
        middleware: createStoreTodosMiddleware(todosRepository, userRepository),
      );

      store.dispatch(new DeleteTodoAction(todo.id));

      verify(todosRepository.deleteTodo([todo.id]));
    });
  });
}
