// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:change_notifier_provider_sample/models.dart';
import 'package:change_notifier_provider_sample/todo_list_model.dart';
import 'package:test/test.dart';

import 'mock_repository.dart';

void main() {
  group('TodoListModel', () {
    test('should check if there are completed todos', () async {
      final model = TodoListModel(
        repository: MockRepository(),
        todos: [Todo('a'), Todo('b'), Todo('c', complete: true)],
      );

      expect(model.numCompleted, 1);
      expect(model.hasCompleted, isTrue);
    });

    test('should calculate the number of active todos', () async {
      final model = TodoListModel(
        repository: MockRepository(),
        todos: [Todo('a'), Todo('b'), Todo('c', complete: true)],
      );

      expect(model.hasActiveTodos, isTrue);
      expect(model.numActive, 2);
    });

    test('should return all todos if the VisibilityFilter is all', () async {
      final todos = [Todo('a'), Todo('b'), Todo('c', complete: true)];
      final model = TodoListModel(
        filter: VisibilityFilter.all,
        repository: MockRepository(),
        todos: todos,
      );

      expect(model.filteredTodos, todos);
    });

    test('should return active todos if the VisibilityFilter is active',
        () async {
      final todo1 = Todo('a');
      final todo2 = Todo('b');
      final todo3 = Todo('c', complete: true);
      final model = TodoListModel(
        filter: VisibilityFilter.active,
        repository: MockRepository(),
        todos: [todo1, todo2, todo3],
      );

      expect(model.filteredTodos, [todo1, todo2]);
    });

    test('should return completed todos if the VisibilityFilter is completed',
        () async {
      final todo1 = Todo('a');
      final todo2 = Todo('b');
      final todo3 = Todo('c', complete: true);
      final model = TodoListModel(
        filter: VisibilityFilter.completed,
        repository: MockRepository(),
        todos: [todo1, todo2, todo3],
      );

      expect(model.filteredTodos, [todo3]);
    });

    test('should clear the completed todos', () async {
      final repository = MockRepository();
      final todo1 = Todo('a');
      final todo2 = Todo('b');
      final todo3 = Todo('c', complete: true);
      final model = TodoListModel(
        repository: repository,
        todos: [todo1, todo2, todo3],
      );

      model.clearCompleted();

      expect(model.todos, [todo1, todo2]);
      expect(repository.saveCount, 1);
    });

    test('toggle all as complete or incomplete', () async {
      final repository = MockRepository();
      final model = TodoListModel(
        repository: repository,
        todos: [Todo('a'), Todo('b'), Todo('c', complete: true)],
      );

      // Toggle all complete
      model.toggleAll();
      expect(model.todos.every((t) => t.complete), isTrue);
      expect(repository.saveCount, 1);

      // Toggle all incomplete
      model.toggleAll();
      expect(model.todos.every((t) => !t.complete), isTrue);
      expect(repository.saveCount, 2);
    });

    test('should add a todo', () async {
      final repository = MockRepository();
      final todo = Todo('A');
      final model = TodoListModel(repository: repository);

      model.addTodo(todo);

      expect(model.todos, [todo]);
      expect(repository.saveCount, 1);
    });

    test('should remove a todo', () async {
      final repository = MockRepository();
      final todo = Todo('A');
      final model = TodoListModel(repository: repository, todos: [todo]);

      model.removeTodo(todo);

      expect(model.todos, []);
      expect(repository.saveCount, 1);
    });

    test('should update a todo', () async {
      final repository = MockRepository();
      final todo1 = Todo('a');
      final todo2 = Todo('b');
      final todo3 = Todo('c', complete: true);
      final update = todo2.copy(complete: true);
      final model = TodoListModel(
        repository: repository,
        todos: [todo1, todo2, todo3],
      );

      model.updateTodo(update);

      expect(model.todos, [todo1, update, todo3]);
      expect(repository.saveCount, 1);
    });

    test('should load todos from the repository', () async {
      final todos = [Todo('a'), Todo('b'), Todo('c', complete: true)];
      final repository = MockRepository(todos);
      final model = TodoListModel(repository: repository);

      expect(model.isLoading, isFalse);
      expect(model.todos, []);

      final loading = model.loadTodos();

      expect(model.isLoading, isTrue);

      await loading;

      expect(model.isLoading, isFalse);
      expect(model.todos, todos);
    });
  });
}
