// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:todos_repository_flutter/todos_repository_flutter.dart';

class MockTodosRepository extends Mock implements TodosRepository {}

main() {
  group('ReactiveTodosRepository', () {
    List<TodoEntity> createTodos([String task = "Task"]) {
      return [
        new TodoEntity(task, "1", "Hallo", false),
        new TodoEntity(task, "2", "Friend", false),
        new TodoEntity(task, "3", "Yo", false),
      ];
    }

    test('should load todos from the base repo and send them to the client',
        () {
      final todos = createTodos();
      final repository = new MockTodosRepository();
      final reactiveRepository = new ReactiveTodosRepositoryFlutter(
          repository: repository, seedValue: todos);

      when(repository.loadTodos()).thenReturn(new Future.value([]));

      expect(reactiveRepository.todos(), emits(todos));
    });

    test('should only load from the base repo once', () {
      final todos = createTodos();
      final repository = new MockTodosRepository();
      final reactiveRepository = new ReactiveTodosRepositoryFlutter(
          repository: repository, seedValue: todos);

      when(repository.loadTodos()).thenReturn(new Future.value([]));

      expect(reactiveRepository.todos(), emits(todos));
      expect(reactiveRepository.todos(), emits(todos));

      verify(repository.loadTodos()).called(1);
    });

    test('should add new todos to the repository and emit the change',
        () async {
      final todos = createTodos();
      final repository = new MockTodosRepository();
      final reactiveRepository = new ReactiveTodosRepositoryFlutter(
        repository: repository,
        seedValue: todos,
      );

      when(repository.loadTodos()).thenReturn(new Future.value([]));
      when(repository.saveTodos(todos)).thenReturn(new Future.value());

      await reactiveRepository.addNewTodo(todos.first);

      verify(repository.saveTodos(any));
      expect(reactiveRepository.todos(), emits(todos..add(todos.first)));
    });

    test('should update a todo in the repository and emit the change',
        () async {
      final todos = createTodos();
      final repository = new MockTodosRepository();
      final reactiveRepository = new ReactiveTodosRepositoryFlutter(
        repository: repository,
        seedValue: todos,
      );
      final update = createTodos("New task");

      when(repository.loadTodos()).thenReturn(new Future.value([]));
      when(repository.saveTodos(any)).thenReturn(new Future.value());

      await reactiveRepository.updateTodo(update.first);

      verify(repository.saveTodos(any));
      expect(
        reactiveRepository.todos(),
        emits([update[0], todos[1], todos[2]]),
      );
    });

    test('should remove todos from the repo and emit the change', () async {
      final repository = new MockTodosRepository();
      final todos = createTodos();
      final reactiveRepository = new ReactiveTodosRepositoryFlutter(
        repository: repository,
        seedValue: todos,
      );
      final future = new Future.value([]);

      when(repository.loadTodos()).thenReturn(future);
      when(repository.saveTodos(any)).thenReturn(new Future.value());

      await reactiveRepository.deleteTodo([todos.first.id, todos.last.id]);

      verify(repository.saveTodos(any));
      expect(reactiveRepository.todos(), emits([todos[1]]));
    });
  });
}
