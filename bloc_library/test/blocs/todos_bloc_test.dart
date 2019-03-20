// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_library/blocs/todos/todos.dart';
import 'package:bloc_library/models/models.dart';
import 'package:todos_repository_simple/todos_repository_simple.dart';

class MockTodosRepository extends Mock implements TodosRepositoryFlutter {}

main() {
  group('TodosBloc', () {
    TodosRepositoryFlutter todosRepository;
    TodosBloc todosBloc;

    setUp(() {
      todosRepository = MockTodosRepository();
      when(todosRepository.loadTodos()).thenAnswer((_) => Future.value([]));
      todosBloc = TodosBloc(todosRepository: todosRepository);
    });

    test('should emit TodosNotLoaded if repository throws', () {
      when(todosRepository.loadTodos()).thenThrow(Exception('oops'));

      expectLater(
        todosBloc.state,
        emitsInOrder([
          TodosLoading(),
          TodosNotLoaded(),
        ]),
      );

      todosBloc.dispatch(LoadTodos());
    });

    test('should add a todo to the list in response to an AddTodo Event', () {
      final todo = Todo("Hallo");

      expectLater(
        todosBloc.state,
        emitsInOrder([
          TodosLoading(),
          TodosLoaded([]),
          TodosLoaded([todo]),
        ]),
      );

      todosBloc.dispatch(LoadTodos());
      todosBloc.dispatch(AddTodo(todo));
    });

    test('should remove from the list in response to a DeleteTodo Event', () {
      final todo = Todo("Hallo");
      when(todosRepository.loadTodos()).thenAnswer((_) => Future.value([]));

      expectLater(
        todosBloc.state,
        emitsInOrder([
          TodosLoading(),
          TodosLoaded([]),
          TodosLoaded([todo]),
          TodosLoaded([]),
        ]),
      );

      todosBloc.dispatch(LoadTodos());
      todosBloc.dispatch(AddTodo(todo));
      todosBloc.dispatch(DeleteTodo(todo));
    });

    test('should update a todo in response to an UpdateTodoAction', () {
      final todo = Todo("Hallo");

      expectLater(
        todosBloc.state,
        emitsInOrder([
          TodosLoading(),
          TodosLoaded([]),
          TodosLoaded([todo]),
          TodosLoaded([todo.copyWith(task: 'Tschüss')]),
        ]),
      );

      todosBloc.dispatch(LoadTodos());
      todosBloc.dispatch(AddTodo(todo));
      todosBloc.dispatch(UpdateTodo(todo.copyWith(task: "Tschüss")));
    });

    test('should clear completed todos', () {
      final todo1 = Todo("Hallo");
      final todo2 = Todo("Tschüss", complete: true);

      expectLater(
        todosBloc.state,
        emitsInOrder([
          TodosLoading(),
          TodosLoaded([]),
          TodosLoaded([todo1]),
          TodosLoaded([todo1, todo2]),
          TodosLoaded([todo1]),
        ]),
      );

      todosBloc.dispatch(LoadTodos());
      todosBloc.dispatch(AddTodo(todo1));
      todosBloc.dispatch(AddTodo(todo2));
      todosBloc.dispatch(ClearCompleted());
    });

    test('should mark all as completed if some todos are incomplete', () {
      final todo1 = Todo("Hallo");
      final todo2 = Todo("Tschüss", complete: true);

      expectLater(
        todosBloc.state,
        emitsInOrder([
          TodosLoading(),
          TodosLoaded([]),
          TodosLoaded([todo1]),
          TodosLoaded([todo1, todo2]),
          TodosLoaded([todo1.copyWith(complete: true), todo2]),
        ]),
      );

      todosBloc.dispatch(LoadTodos());
      todosBloc.dispatch(AddTodo(todo1));
      todosBloc.dispatch(AddTodo(todo2));
      todosBloc.dispatch(ToggleAll());
    });

    test('should mark all as incomplete if all todos are complete', () {
      final todo1 = Todo("Hallo", complete: true);
      final todo2 = Todo("Tschüss", complete: true);

      expectLater(
        todosBloc.state,
        emitsInOrder([
          TodosLoading(),
          TodosLoaded([]),
          TodosLoaded([todo1]),
          TodosLoaded([todo1, todo2]),
          TodosLoaded([
            todo1.copyWith(complete: false),
            todo2.copyWith(complete: false)
          ]),
        ]),
      );

      todosBloc.dispatch(LoadTodos());
      todosBloc.dispatch(AddTodo(todo1));
      todosBloc.dispatch(AddTodo(todo2));
      todosBloc.dispatch(ToggleAll());
    });
  });
}
