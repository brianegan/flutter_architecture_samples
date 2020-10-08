// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:rvms_model_sample/display_todos/_manager/todo_manager_.dart';
import 'package:rvms_model_sample/display_todos/_manager/todo_manager_implementation.dart';
import 'package:rvms_model_sample/display_todos/_model/todo.dart';
import 'package:rvms_model_sample/display_todos/_services/repository_service_.dart';
import 'package:test/test.dart';

final locator = GetIt.instance;
main() {
  group('TodoManagerImplementation', () {
    setUp(() async {
      await locator.reset();
    });
    test('should check if there are completed todos', () async {
      locator.registerSingleton<RepositoryService>(MockRepositoryService([
        Todo('a'),
        Todo('b'),
        Todo('c', complete: true),
      ]));
      final todoManager = TodoManagerImplementation();
      await todoManager.loadTodos();

      expect(todoManager.filteredTodos.value.any((it) => it.complete), true);
    });

    test('should calculate the number of active todos', () async {
      locator.registerSingleton<RepositoryService>(MockRepositoryService([
        Todo('a'),
        Todo('b'),
        Todo('c', complete: true),
      ]));
      final todoManager = TodoManagerImplementation();
      await todoManager.loadTodos();

      expect(
          todoManager.filteredTodos.value
              .where((it) => !it.complete)
              .toList()
              .length,
          2);
    });

    test('should calculate the number of completed todos', () async {
      locator.registerSingleton<RepositoryService>(MockRepositoryService([
        Todo('a'),
        Todo('b'),
        Todo('c', complete: true),
      ]));
      final todoManager = TodoManagerImplementation();
      await todoManager.loadTodos();

      expect(
          todoManager.filteredTodos.value
              .where((it) => it.complete)
              .toList()
              .length,
          1);
    });

    test('should return all todos if the VisibilityFilter is all', () async {
      final todos = [
        Todo('a'),
        Todo('b'),
        Todo('c', complete: true),
      ];
      locator
          .registerSingleton<RepositoryService>(MockRepositoryService(todos));
      final todoManager = TodoManagerImplementation();
      await todoManager.loadTodos();

      expect(todoManager.filteredTodos.value, todos);
    });

    test('should return active todos if the VisibilityFilter is active',
        () async {
      final todo1 = Todo('a');
      final todo2 = Todo('b');
      final todo3 = Todo('c', complete: true);
      final todos = [
        todo1,
        todo2,
        todo3,
      ];
      locator
          .registerSingleton<RepositoryService>(MockRepositoryService(todos));
      final todoManager =
          TodoManagerImplementation(activeFilter: VisibilityFilter.active);

      await todoManager.loadTodos();
      expect(todoManager.filteredTodos.value, [
        todo1,
        todo2,
      ]);
    });

    test('should return completed todos if the VisibilityFilter is completed',
        () async {
      final todo1 = Todo('a');
      final todo2 = Todo('b');
      final todo3 = Todo('c', complete: true);
      final todos = [
        todo1,
        todo2,
        todo3,
      ];
      locator
          .registerSingleton<RepositoryService>(MockRepositoryService(todos));
      final todoManager =
          TodoManagerImplementation(activeFilter: VisibilityFilter.completed);
      await todoManager.loadTodos();

      expect(todoManager.filteredTodos.value, [todo3]);
    });

    test('should clear the completed todos', () async {
      final todo1 = Todo('a');
      final todo2 = Todo('b');
      final todo3 = Todo('c', complete: true);
      final todos = [
        todo1,
        todo2,
        todo3,
      ];
      locator
          .registerSingleton<RepositoryService>(MockRepositoryService(todos));
      final todoManager = TodoManagerImplementation();
      await todoManager.loadTodos();

      todoManager.clearCompletedCommand();

      expect(todoManager.filteredTodos.value, [
        todo1,
        todo2,
      ]);
    });

    test('toggle all as complete or incomplete', () async {
      final todo1 = Todo('a');
      final todo2 = Todo('b');
      final todo3 = Todo('c', complete: true);
      final todos = [
        todo1,
        todo2,
        todo3,
      ];
      locator
          .registerSingleton<RepositoryService>(MockRepositoryService(todos));
      final todoManager = TodoManagerImplementation();

      await todoManager.loadTodos();

      // Toggle all complete
      todoManager.toggleAll();
      expect(todoManager.filteredTodos.value.every((t) => t.complete), isTrue);

      // Toggle all incomplete
      todoManager.toggleAll();
      expect(todoManager.filteredTodos.value.every((t) => !t.complete), isTrue);
    });
  });
}

class MockRepositoryService extends RepositoryService {
  List<Todo> entities;

  MockRepositoryService(List<Todo> todos) : this.entities = todos;

  @override
  Future<List<Todo>> loadTodos() {
    return Future.value(entities);
  }

  @override
  Future saveTodos(List<Todo> todos) {
    return Future.sync(() => entities = todos);
  }
}
