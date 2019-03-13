// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_library/blocs/blocs.dart';
import 'package:bloc_library/models/models.dart';

class MockTodosBloc extends Mock implements TodosBloc {}

main() {
  group('FilteredTodosBloc', () {
    test('should update the VisibilityFilter', () {
      final todo = Todo('Wash Dishes');
      final todosBloc = MockTodosBloc();
      when(todosBloc.state).thenAnswer((_) => Stream.empty());
      when(todosBloc.currentState).thenReturn(TodosLoaded([todo]));
      final FilteredTodosBloc filteredTodosBloc = FilteredTodosBloc(
        todosBloc: todosBloc,
      );

      expect(
        filteredTodosBloc.initialState,
        FilteredTodosState([todo], VisibilityFilter.all),
      );

      expectLater(
        filteredTodosBloc.state,
        emitsInOrder([
          FilteredTodosState([todo], VisibilityFilter.all),
          FilteredTodosState([], VisibilityFilter.completed),
        ]),
      );

      filteredTodosBloc.dispatch(UpdateFilter(VisibilityFilter.completed));
    });
  });
}
