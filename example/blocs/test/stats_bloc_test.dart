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
      final interactor = new MockTodosInteractor();
      final todos = [
        new Todo("Hallo", complete: true),
        new Todo("Friend"),
      ];
      final source = new BehaviorSubject<List<Todo>>(seedValue: todos);

      when(interactor.todos).thenReturn(source.stream);

      final bloc = new StatsBloc(interactor);

      expect(bloc.numActive, emits(1));
    });

    test('should stream the number of completed todos', () {
      final interactor = new MockTodosInteractor();
      final todos = [
        new Todo("Hallo", complete: true),
        new Todo("Friend", complete: true),
      ];
      final source = new BehaviorSubject<List<Todo>>(seedValue: todos);

      when(interactor.todos).thenReturn(source.stream);

      final bloc = new StatsBloc(interactor);

      expect(bloc.numComplete, emits(2));
    });
  });
}
