// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:fire_redux_sample/actions/actions.dart';
import 'package:fire_redux_sample/middleware/store_todos_middleware.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:fire_redux_sample/reducers/app_state_reducer.dart';
import 'package:flutter/foundation.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:test/test.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

class MockReactiveTodosRepository extends Mock
    implements ReactiveTodosRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockMiddleware extends Mock implements MiddlewareClass<AppState> {}

void main() {
  group('Middleware', () {
    test('should log in and start listening for changes', () {
      final todosRepository = MockReactiveTodosRepository();
      final userRepository = MockUserRepository();
      final captor = MockMiddleware();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.loading(),
        middleware: createStoreTodosMiddleware(todosRepository, userRepository)
          ..add(captor),
      );

      when(userRepository.login()).thenAnswer((_) => SynchronousFuture(null));
      when(todosRepository.todos())
          .thenAnswer((_) => StreamController<List<TodoEntity>>().stream);

      store.dispatch(InitAppAction());

      verify(userRepository.login());
      verify(todosRepository.todos());
      verify(captor.call(
        any,
        TypeMatcher<ConnectToDataSourceAction>(),
        any,
      ) as dynamic);
    });

    test('should convert entities to todos', () async {
      // ignore: close_sinks
      final controller = StreamController<List<TodoEntity>>(sync: true);
      final todo = Todo('A');
      final todosRepository = MockReactiveTodosRepository();
      final userRepository = MockUserRepository();
      final captor = MockMiddleware();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.loading(),
        middleware: createStoreTodosMiddleware(todosRepository, userRepository)
          ..add(captor),
      );

      when(todosRepository.todos()).thenAnswer((_) => controller.stream);

      store.dispatch(ConnectToDataSourceAction());
      controller.add([todo.toEntity()]);

      verify(captor.call(
        any,
        TypeMatcher<LoadTodosAction>(),
        any,
      ) as dynamic);
    });

    test('should send todos to the repository', () {
      final todo = Todo('T');
      final todosRepository = MockReactiveTodosRepository();
      final userRepository = MockUserRepository();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.loading(),
        middleware: createStoreTodosMiddleware(todosRepository, userRepository),
      );

      store.dispatch(AddTodoAction(todo));
      verify(todosRepository.addNewTodo(todo.toEntity()));
    });

    test('should clear the completed todos from the repository', () {
      final todoA = Todo('A');
      final todoB = Todo('B', complete: true);
      final todoC = Todo('C', complete: true);
      final todosRepository = MockReactiveTodosRepository();
      final userRepository = MockUserRepository();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(todos: [
          todoA,
          todoB,
          todoC,
        ]),
        middleware: createStoreTodosMiddleware(todosRepository, userRepository),
      );

      store.dispatch(ClearCompletedAction());

      verify(todosRepository.deleteTodo([todoB.id, todoC.id]));
    });

    test('should inform the repository to toggle all todos active', () {
      final todoA = Todo('A', complete: true);
      final todoB = Todo('B', complete: true);
      final todosRepository = MockReactiveTodosRepository();
      final userRepository = MockUserRepository();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(todos: [
          todoA,
          todoB,
        ]),
        middleware: createStoreTodosMiddleware(todosRepository, userRepository),
      );

      store.dispatch(ToggleAllAction());

      verify(todosRepository
          .updateTodo(todoA.copyWith(complete: false).toEntity()));
      verify(todosRepository
          .updateTodo(todoB.copyWith(complete: false).toEntity()));
    });

    test('should inform the repository to toggle all todos complete', () {
      final todoA = Todo('A');
      final todoB = Todo('B', complete: true);
      final todosRepository = MockReactiveTodosRepository();
      final userRepository = MockUserRepository();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(todos: [
          todoA,
          todoB,
        ]),
        middleware: createStoreTodosMiddleware(todosRepository, userRepository),
      );

      store.dispatch(ToggleAllAction());

      verify(todosRepository
          .updateTodo(todoA.copyWith(complete: true).toEntity()));
    });

    test('should update a todo on firestore', () {
      final todo = Todo('A');
      final update = todo.copyWith(task: 'B');
      final todosRepository = MockReactiveTodosRepository();
      final userRepository = MockUserRepository();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(todos: [todo]),
        middleware: createStoreTodosMiddleware(todosRepository, userRepository),
      );

      store.dispatch(UpdateTodoAction(todo.id, update));

      verify(todosRepository.updateTodo(update.toEntity()));
    });

    test('should delete a todo on firestore', () {
      final todo = Todo('A');
      final todosRepository = MockReactiveTodosRepository();
      final userRepository = MockUserRepository();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(todos: [todo]),
        middleware: createStoreTodosMiddleware(todosRepository, userRepository),
      );

      store.dispatch(DeleteTodoAction(todo.id));

      verify(todosRepository.deleteTodo([todo.id]));
    });
  });
}
