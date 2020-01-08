// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:built_redux_sample/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Selector Tests', () {
    test('should calculate the number of active todos', () {
      final state = AppState.fromTodos([
        Todo('a'),
        Todo('b'),
        Todo.builder(
          (b) => b
            ..task = 'c'
            ..complete = true,
        ),
      ]);

      expect(state.numActiveSelector, 2);
    });

    test('should calculate the number of completed todos', () {
      final state = AppState.fromTodos([
        Todo('a'),
        Todo('b'),
        Todo.builder(
          (b) => b
            ..task = 'c'
            ..complete = true,
        ),
      ]);

      expect(state.numCompletedSelector, 1);
    });

    test('should return all todos if the VisibilityFilter is all', () {
      final todos = [
        Todo('a'),
        Todo('b'),
        Todo.builder(
          (b) => b
            ..task = 'c'
            ..complete = true,
        ),
      ];
      final state = AppState.fromTodos(todos);
      expect(state.activeFilter, VisibilityFilter.all);
      expect(state.filteredTodosSelector, todos);
    });

    test('should return active todos if the VisibilityFilter is active', () {
      final todo1 = Todo('a');
      final todo2 = Todo('b');
      final todo3 = Todo.builder(
        (b) => b
          ..task = 'c'
          ..complete = true,
      );
      final todos = [
        todo1,
        todo2,
        todo3,
      ];
      final state = AppState.fromTodos(todos)
          .rebuild((b) => b.activeFilter = VisibilityFilter.active);

      expect(state.filteredTodosSelector, [todo1, todo2]);
    });

    test('should return completed todos if the VisibilityFilter is completed',
        () {
      final todo1 = Todo('a');
      final todo2 = Todo('b');
      final todo3 = Todo.builder(
        (b) => b
          ..task = 'c'
          ..complete = true,
      );
      final todos = [
        todo1,
        todo2,
        todo3,
      ];
      final state = AppState.fromTodos(todos)
          .rebuild((b) => b.activeFilter = VisibilityFilter.completed);

      expect(state.filteredTodosSelector, [todo3]);
    });
  });
}
