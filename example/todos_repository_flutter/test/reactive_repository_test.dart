// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:todos_repository_flutter/todos_repository_flutter.dart';

/// We create two Mocks for our Web Client and File Storage. We will use these
/// mock classes to verify the behavior of the TodosRepository.
class MockTodosRepository extends Mock implements TodosRepository {}

main() {
  group('ReactiveTodosRepository', () {
    List<TodoEntity> createTodos([String task = "Task"]) {
      return [new TodoEntity(task, "1", "Hallo", false)];
    }

    test('should load todos from the base repo and send them to the client',
        () {
      final repository = new MockTodosRepository();
      final reactiveRepository = new ReactiveTodosRepositoryFlutter(
        repository: repository,
      );
      final todos = createTodos();

      when(repository.loadTodos()).thenReturn(new Future.value(todos));

      expect(reactiveRepository.todos(), emits(todos));
    });

    test('should only load from the base repo once', () {
      final repository = new MockTodosRepository();
      final reactiveRepository = new ReactiveTodosRepositoryFlutter(
        repository: repository,
      );
      final todos = createTodos();

      when(repository.loadTodos()).thenReturn(new Future.value(todos));

      expect(reactiveRepository.todos(), emits(todos));
      expect(reactiveRepository.todos(), emits(todos));

      verify(repository.loadTodos()).called(1);
    });

    test('should add new todos to the repository and emit the change',
        () async {
      final repository = new MockTodosRepository();
      final reactiveRepository = new ReactiveTodosRepositoryFlutter(
        repository: repository,
      );
      final todos = createTodos();

      when(repository.loadTodos()).thenReturn(new Future.value([]));
      when(repository.saveTodos(todos)).thenReturn(new Future.value());

      await reactiveRepository.addNewTodo(todos.first);

      verify(repository.saveTodos(todos));
      expect(reactiveRepository.todos(), emits(todos));
    });

    test('should update a todo to the repository and emit the change',
        () async {
      final repository = new MockTodosRepository();
      final reactiveRepository = new ReactiveTodosRepositoryFlutter(
        repository: repository,
      );
      final todos = createTodos();
      final update = createTodos("New task");

      when(repository.loadTodos()).thenReturn(new Future.value(todos));
      when(repository.saveTodos(any)).thenReturn(new Future.value());

      await reactiveRepository.updateTodo(todos.first);

      verify(repository.saveTodos(todos));
      expect(reactiveRepository.todos(), emits(todos));
    });
  });
}
