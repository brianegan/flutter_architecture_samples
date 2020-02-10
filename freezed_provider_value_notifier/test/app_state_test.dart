// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:freezed_provider_value_notifier/models.dart';
import 'package:freezed_provider_value_notifier/todo_list_model.dart';
import 'package:test/test.dart';

import 'mock_repository.dart';

void main() {
  group('TodoListModel', () {
    test('should check if there are completed todos', () async {
      final model = TodoListController(
        todosRepository: MockRepository(),
        todos: [Todo('a'), Todo('b'), Todo('c', complete: true)],
      );

      expect(model.value.numCompleted, 1);
      expect(model.value.hasCompleted, isTrue);
    });

    test('should calculate the number of active todos', () async {
      final model = TodoListController(
        todosRepository: MockRepository(),
        todos: [Todo('a'), Todo('b'), Todo('c', complete: true)],
      );

      expect(model.value.hasActiveTodos, isTrue);
      expect(model.value.numActive, 2);
    });

    test('should return all todos if the VisibilityFilter is all', () async {
      final todos = [Todo('a'), Todo('b'), Todo('c', complete: true)];
      final model = TodoListController(
        filter: VisibilityFilter.all,
        todosRepository: MockRepository(),
        todos: todos,
      );

      expect(model.value.filteredTodos, todos);
    });

    test('should return active todos if the VisibilityFilter is active',
        () async {
      final todo1 = Todo('a');
      final todo2 = Todo('b');
      final todo3 = Todo('c', complete: true);
      final model = TodoListController(
        filter: VisibilityFilter.active,
        todosRepository: MockRepository(),
        todos: [todo1, todo2, todo3],
      );

      expect(model.value.filteredTodos, [todo1, todo2]);
    });

    test('should return completed todos if the VisibilityFilter is completed',
        () async {
      final todo1 = Todo('a');
      final todo2 = Todo('b');
      final todo3 = Todo('c', complete: true);
      final model = TodoListController(
        filter: VisibilityFilter.completed,
        todosRepository: MockRepository(),
        todos: [todo1, todo2, todo3],
      );

      expect(model.value.filteredTodos, [todo3]);
    });

    test('should clear the completed todos', () async {
      final repository = MockRepository();
      final todo1 = Todo('a');
      final todo2 = Todo('b');
      final todo3 = Todo('c', complete: true);
      final model = TodoListController(
        todosRepository: repository,
        todos: [todo1, todo2, todo3],
      );

      model.clearCompleted();

      expect(
        model.value.todos,
        [todo1, todo2],
      );
      expect(repository.saveCount, 1);
    });

    test('toggle all as complete or incomplete', () async {
      final repository = MockRepository();
      final model = TodoListController(
        todosRepository: repository,
        todos: [Todo('a'), Todo('b'), Todo('c', complete: true)],
      );

      // Toggle all complete
      model.toggleAll();
      expect(model.value.todos.every((t) => t.complete), isTrue);
      expect(repository.saveCount, 1);

      // Toggle all incomplete
      model.toggleAll();
      expect(model.value.todos.every((t) => !t.complete), isTrue);
      expect(repository.saveCount, 2);
    });

    test('should add a todo', () async {
      final repository = MockRepository();
      final todo = Todo('A');
      final model = TodoListController(todosRepository: repository);

      model.addTodo(todo);

      expect(
        model.value.todos,
        [todo],
      );

      expect(repository.saveCount, 1);
    });

    test('should remove a todo', () async {
      final repository = MockRepository();
      final todo = Todo('A');
      final model =
          TodoListController(todosRepository: repository, todos: [todo]);

      model.removeTodoWithId(todo.id);

      expect(
        model.value.todos,
        [],
      );
      expect(repository.saveCount, 1);
    });

    test('should update a todo', () async {
      final repository = MockRepository();
      final todo1 = Todo('a');
      final todo2 = Todo('b');
      final todo3 = Todo('c', complete: true);
      final update = todo2.copy(complete: true);
      final model = TodoListController(
        todosRepository: repository,
        todos: [todo1, todo2, todo3],
      );

      model.updateTodo(update);

      expect(
        model.value.todos,
        [todo1, update, todo3],
      );
      expect(repository.saveCount, 1);
    });
  });
}
