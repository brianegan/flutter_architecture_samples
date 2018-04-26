// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:vanilla/models.dart';

main() {
  group('AppState', () {
    test('should check if there are completed todos', () {
      final state = AppState(todos: [
        Todo('a'),
        Todo('b'),
        Todo('c', complete: true),
      ]);

      expect(state.hasCompletedTodos, true);
    });

    test('should calculate the number of active todos', () {
      final state = AppState(todos: [
        Todo('a'),
        Todo('b'),
        Todo('c', complete: true),
      ]);

      expect(state.numActive, 2);
    });

    test('should calculate the number of completed todos', () {
      final state = AppState(todos: [
        Todo('a'),
        Todo('b'),
        Todo('c', complete: true),
      ]);

      expect(state.numCompleted, 1);
    });

    test('should return all todos if the VisibilityFilter is all', () {
      final todos = [
        Todo('a'),
        Todo('b'),
        Todo('c', complete: true),
      ];
      final state = AppState(
        todos: todos,
      );

      expect(state.filteredTodos(VisibilityFilter.all), todos);
    });

    test('should return active todos if the VisibilityFilter is active', () {
      final todo1 = Todo('a');
      final todo2 = Todo('b');
      final todo3 = Todo('c', complete: true);
      final todos = [
        todo1,
        todo2,
        todo3,
      ];
      final state = AppState(
        todos: todos,
      );

      expect(state.filteredTodos(VisibilityFilter.active), [
        todo1,
        todo2,
      ]);
    });

    test('should return completed todos if the VisibilityFilter is completed',
        () {
      final todo1 = Todo('a');
      final todo2 = Todo('b');
      final todo3 = Todo('c', complete: true);
      final todos = [
        todo1,
        todo2,
        todo3,
      ];
      final state = AppState(
        todos: todos,
      );

      expect(state.filteredTodos(VisibilityFilter.completed), [todo3]);
    });

    test('should clear the completed todos', () {
      final todo1 = Todo('a');
      final todo2 = Todo('b');
      final todo3 = Todo('c', complete: true);
      final todos = [
        todo1,
        todo2,
        todo3,
      ];
      final state = AppState(
        todos: todos,
      );

      state.clearCompleted();

      expect(state.todos, [
        todo1,
        todo2,
      ]);
    });

    test('toggle all as complete or incomplete', () {
      final todo1 = Todo('a');
      final todo2 = Todo('b');
      final todo3 = Todo('c', complete: true);
      final todos = [
        todo1,
        todo2,
        todo3,
      ];
      final state = AppState(
        todos: todos,
      );

      // Toggle all complete
      state.toggleAll();
      expect(state.todos.every((t) => t.complete), isTrue);

      // Toggle all incomplete
      state.toggleAll();
      expect(state.todos.every((t) => !t.complete), isTrue);
    });
  });
}
