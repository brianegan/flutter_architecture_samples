// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:blocs/blocs.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';
import 'package:todos_repository/todos_repository.dart';

class MockReactiveTodosRepository extends Mock
    implements ReactiveTodosRepository {}

void main() {
  group('StatsBloc', () {
    test('should stream the number of active todos', () {
      final repository = new MockReactiveTodosRepository();
      final todos = [
        new TodoEntity("Hallo", "1", "Note", false),
        new TodoEntity("Friend", "2", "Note", true),
      ];
      final source = new BehaviorSubject<List<TodoEntity>>(seedValue: todos);

      when(repository.todos()).thenReturn(source.stream);

      final bloc = new StatsBloc(repository);

      expect(bloc.numActive, emits(1));
    });

    test('should stream the number of completed todos', () {
      final repository = new MockReactiveTodosRepository();
      final todos = [
        new TodoEntity("Hallo", "1", "Note", true),
        new TodoEntity("Friend", "2", "Note", true),
      ];
      final source = new BehaviorSubject<List<TodoEntity>>(seedValue: todos);

      when(repository.todos()).thenReturn(source.stream);

      final bloc = new StatsBloc(repository);

      expect(bloc.numComplete, emits(2));
    });
  });
}
