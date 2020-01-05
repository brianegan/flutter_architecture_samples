// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:mobx/mobx.dart';
import 'package:mobx_sample/models/todo.dart';
import 'package:mobx_sample/stores/todo_store.dart';
import 'package:todos_repository_core/todos_repository_core.dart';
import 'package:test/test.dart';

import 'mock_repository.dart';

/// Demonstrates how to test mobx stores. The TodoStore is a pure Dart class and
/// can be tested with the raw test package independent of any widgets!
///
/// To provide a mock data source, a [MockRepository] is used.
void main() {
  group('TodoStore', () {
    test('should check if there are pending todos', () {
      final hasPendingStore = TodoStore(
        MockRepository(),
        todos: ObservableList.of([
          Todo(task: 'a'),
          Todo(task: 'b', complete: true),
        ]),
      );
      final noPendingStore = TodoStore(
        MockRepository(),
        todos: ObservableList.of([
          Todo(task: 'a', complete: true),
        ]),
      );

      expect(hasPendingStore.hasPendingTodos, isTrue);
      expect(noPendingStore.hasPendingTodos, isFalse);
    });

    test('should check if there are completed todos', () {
      final hasCompletedStore = TodoStore(
        MockRepository(),
        todos: ObservableList.of([
          Todo(task: 'a'),
          Todo(task: 'b', complete: true),
        ]),
      );
      final noCompletedStore = TodoStore(
        MockRepository(),
        todos: ObservableList.of([
          Todo(task: 'a'),
        ]),
      );

      expect(hasCompletedStore.hasCompletedTodos, isTrue);
      expect(noCompletedStore.hasCompletedTodos, isFalse);
    });

    test('should calculate the number of pending todos', () {
      final store = TodoStore(
        MockRepository(),
        todos: ObservableList.of([
          Todo(task: 'a'),
          Todo(task: 'b'),
          Todo(task: 'c', complete: true),
        ]),
      );

      expect(store.numPending, 2);
    });

    test('should calculate the number of completed todos', () {
      final store = TodoStore(
        MockRepository(),
        todos: ObservableList.of([
          Todo(task: 'a'),
          Todo(task: 'b'),
          Todo(task: 'c', complete: true),
        ]),
      );

      expect(store.numCompleted, 1);
    });

    test('should return all todos with VisibilityFilter.all', () {
      final todos = [
        Todo(task: 'a'),
        Todo(task: 'b'),
        Todo(task: 'c', complete: true),
      ];
      final store = TodoStore(
        MockRepository(),
        todos: ObservableList.of(todos),
      );

      expect(store.visibleTodos, todos);
    });

    test('should return active todos with VisibilityFilter.pending', () {
      final todo1 = Todo(task: 'a');
      final todo2 = Todo(task: 'b');
      final todo3 = Todo(task: 'c', complete: true);
      final store = TodoStore(
        MockRepository(),
        todos: ObservableList.of([todo1, todo2, todo3]),
        filter: VisibilityFilter.pending,
      );

      expect(store.visibleTodos, [todo1, todo2]);
    });

    test('should return completed todos with VisibilityFilter.completed', () {
      final todo1 = Todo(task: 'a');
      final todo2 = Todo(task: 'b');
      final todo3 = Todo(task: 'c', complete: true);
      final store = TodoStore(
        MockRepository(),
        todos: ObservableList.of([todo1, todo2, todo3]),
        filter: VisibilityFilter.completed,
      );

      expect(store.visibleTodos, [todo3]);
    });

    test('should clear the completed todos', () async {
      final todo1 = Todo(task: 'a');
      final todo2 = Todo(task: 'b');
      final todo3 = Todo(task: 'c', complete: true);
      final store = TodoStore(
        MockRepository(),
        todos: ObservableList.of([todo1, todo2, todo3]),
      );

      store.clearCompleted();

      expect(store.todos, [todo1, todo2]);
    });

    test('toggle all as complete or incomplete', () async {
      final todo1 = Todo(task: 'a');
      final todo2 = Todo(task: 'b');
      final todo3 = Todo(task: 'c', complete: true);
      final store = TodoStore(
        MockRepository(),
        todos: ObservableList.of([todo1, todo2, todo3]),
      );

      // Toggle all complete
      store.toggleAll();
      expect(store.todos.every((t) => t.complete), isTrue);

      // Toggle all incomplete
      store.toggleAll();
      expect(store.todos.every((t) => !t.complete), isTrue);
    });

    test('should listen to changes and persist to the repository', () async {
      final repository = MockRepository([
        TodoEntity('a', '1', '', false),
        TodoEntity('b', '2', '', false),
        TodoEntity('c', '3', '', true),
      ]);
      final store = TodoStore(repository, saveDelay: null);
      final todo = Todo();

      // Loading from the repo does not immediately save back to the repo
      await store.init();
      expect(repository.saveCount, 0);

      // Changing an individual item triggers a save
      store.todos.first.task = 'x';
      expect(repository.saveCount, 1);

      // Adding an item triggers a save
      store.todos.add(todo);
      expect(repository.saveCount, 2);

      // Removing an item triggers a save
      store.todos.remove(todo);
      expect(repository.saveCount, 3);
    });
  });
}
