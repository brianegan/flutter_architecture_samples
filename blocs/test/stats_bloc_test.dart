// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:blocs/blocs.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

class MockTodosInteractor extends Mock implements TodosInteractor {}

void main() {
  group('StatsBloc', () {
    test('should stream the number of active todos', () {
      final interactor = MockTodosInteractor();
      final todos = [
        Todo('Hallo', complete: true),
        Todo('Friend'),
      ];
      final source = BehaviorSubject<List<Todo>>.seeded(todos);

      when(interactor.todos).thenAnswer((_) => source.stream);

      final bloc = StatsBloc(interactor);

      expect(bloc.numActive, emits(1));
    });

    test('should stream the number of completed todos', () {
      final interactor = MockTodosInteractor();
      final todos = [
        Todo('Hallo', complete: true),
        Todo('Friend', complete: true),
      ];
      final source = BehaviorSubject<List<Todo>>.seeded(todos);

      when(interactor.todos).thenAnswer((_) => source.stream);

      final bloc = StatsBloc(interactor);

      expect(bloc.numComplete, emits(2));
    });
  });
}
