// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:scoped_model_sample/models.dart';
import 'package:scoped_model_sample/todo_list_model.dart';
import 'package:test/test.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

void main() {
  group('TodoListModel', () {
    test('should check if there are completed todos', () async {
      final model = TodoListModel(
          repository: MockRepository([
        Todo('a'),
        Todo('b'),
        Todo('c', complete: true),
      ]));
      await model.loadTodos();

      expect(model.todos.any((it) => it.complete), true);
    });

    test('should calculate the number of active todos', () async {
      final model = TodoListModel(
          repository: MockRepository([
        Todo('a'),
        Todo('b'),
        Todo('c', complete: true),
      ]));
      await model.loadTodos();

      expect(model.todos.where((it) => !it.complete).toList().length, 2);
    });

    test('should calculate the number of completed todos', () async {
      final model = TodoListModel(
          repository: MockRepository([
        Todo('a'),
        Todo('b'),
        Todo('c', complete: true),
      ]));
      await model.loadTodos();

      expect(model.todos.where((it) => it.complete).toList().length, 1);
    });

    test('should return all todos if the VisibilityFilter is all', () async {
      final todos = [
        Todo('a'),
        Todo('b'),
        Todo('c', complete: true),
      ];
      final model = TodoListModel(
          repository: MockRepository(todos),
          activeFilter: VisibilityFilter.all);
      await model.loadTodos();

      expect(model.filteredTodos, todos);
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
      final model = TodoListModel(
        repository: MockRepository(todos),
        activeFilter: VisibilityFilter.active,
      );
      await model.loadTodos();

      expect(model.filteredTodos, [
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
      final model = TodoListModel(
        repository: MockRepository(todos),
        activeFilter: VisibilityFilter.completed,
      );
      await model.loadTodos();

      expect(model.filteredTodos, [todo3]);
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
      final model = TodoListModel(
        repository: MockRepository(todos),
      );
      await model.loadTodos();

      model.clearCompleted();

      expect(model.todos, [
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
      final model = TodoListModel(
        repository: MockRepository(todos),
      );
      await model.loadTodos();

      // Toggle all complete
      model.toggleAll();
      expect(model.todos.every((t) => t.complete), isTrue);

      // Toggle all incomplete
      model.toggleAll();
      expect(model.todos.every((t) => !t.complete), isTrue);
    });
  });
}

class MockRepository extends TodosRepository {
  List<TodoEntity> entities;

  MockRepository(List<Todo> todos)
      : entities = todos.map((it) => it.toEntity()).toList();

  @override
  Future<List<TodoEntity>> loadTodos() {
    return Future.value(entities);
  }

  @override
  Future saveTodos(List<TodoEntity> todos) {
    return Future.sync(() => entities = todos);
  }
}
