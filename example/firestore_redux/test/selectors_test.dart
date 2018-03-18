// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved. 
// Use of this source code is governed by the MIT license that can be found 
// in the LICENSE file.

import 'package:quiver/core.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fire_redux_sample/selectors/selectors.dart';

main() {
  group('Selectors', () {
    test('should list the active todos', () {
      final todoA = new Todo('a');
      final todoB = new Todo('b');
      final todos = [
        todoA,
        todoB,
        new Todo('c', complete: true),
      ];

      expect(activeTodosSelector(todos), [todoA, todoB]);
    });

    test('should calculate the number of active todos', () {
      final todos = [
        new Todo('a'),
        new Todo('b'),
        new Todo('c', complete: true),
      ];

      expect(numActiveSelector(todos), 2);
    });

    test('should list the completed todos', () {
      final todo = new Todo('c', complete: true);
      final todos = [
        new Todo('a'),
        new Todo('b'),
        todo,
      ];

      expect(completeTodosSelector(todos), [todo]);
    });

    test('should calculate the number of completed todos', () {
      final todos = [
        new Todo('a'),
        new Todo('b'),
        new Todo('c', complete: true),
      ];

      expect(numCompletedSelector(todos), 1);
    });

    test('should return all todos if the VisibilityFilter is all', () {
      final todos = [
        new Todo('a'),
        new Todo('b'),
        new Todo('c', complete: true),
      ];

      expect(filteredTodosSelector(todos, VisibilityFilter.all), todos);
    });

    test('should return active todos if the VisibilityFilter is active', () {
      final todo1 = new Todo('a');
      final todo2 = new Todo('b');
      final todo3 = new Todo('c', complete: true);
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
      final todo1 = new Todo('a');
      final todo2 = new Todo('b');
      final todo3 = new Todo('c', complete: true);
      final todos = [
        todo1,
        todo2,
        todo3,
      ];

      expect(filteredTodosSelector(todos, VisibilityFilter.completed), [todo3]);
    });

    test('should return an Optional todo based on id', () {
      final todo1 = new Todo('a', id: "1");
      final todo2 = new Todo('b');
      final todo3 = new Todo('c', complete: true);
      final todos = [
        todo1,
        todo2,
        todo3,
      ];

      expect(todoSelector(todos, "1"), new Optional.of(todo1));
    });

    test('should return an absent Optional if the id is not found', () {
      final todo1 = new Todo('a', id: "1");
      final todo2 = new Todo('b');
      final todo3 = new Todo('c', complete: true);
      final todos = [
        todo1,
        todo2,
        todo3,
      ];

      expect(todoSelector(todos, "2"), new Optional.absent());
    });
  });
}
