// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:quiver/core.dart';
import 'package:redux_sample/models/models.dart';
import 'package:redux_sample/selectors/selectors.dart';

void main() {
  group('Selectors', () {
    test('should calculate the number of active todos', () {
      final todos = [
        Todo('a'),
        Todo('b'),
        Todo('c', complete: true),
      ];

      expect(numActiveSelector(todos), 2);
    });

    test('should calculate the number of completed todos', () {
      final todos = [
        Todo('a'),
        Todo('b'),
        Todo('c', complete: true),
      ];

      expect(numCompletedSelector(todos), 1);
    });

    test('should return all todos if the VisibilityFilter is all', () {
      final todos = [
        Todo('a'),
        Todo('b'),
        Todo('c', complete: true),
      ];

      expect(filteredTodosSelector(todos, VisibilityFilter.all), todos);
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

      expect(filteredTodosSelector(todos, VisibilityFilter.active), [
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

      expect(filteredTodosSelector(todos, VisibilityFilter.completed), [todo3]);
    });

    test('should return an Optional todo based on id', () {
      final todo1 = Todo('a', id: '1');
      final todo2 = Todo('b');
      final todo3 = Todo('c', complete: true);
      final todos = [
        todo1,
        todo2,
        todo3,
      ];

      expect(todoSelector(todos, '1'), Optional.of(todo1));
    });

    test('should return an absent Optional if the id is not found', () {
      final todo1 = Todo('a', id: '1');
      final todo2 = Todo('b');
      final todo3 = Todo('c', complete: true);
      final todos = [
        todo1,
        todo2,
        todo3,
      ];

      expect(todoSelector(todos, '2'), Optional.absent());
    });
  });
}
