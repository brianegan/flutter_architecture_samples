// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_library/blocs/blocs.dart';
import 'package:bloc_library/models/models.dart';
import 'package:todos_repository_simple/todos_repository_simple.dart';

class MockTodosBloc extends Mock implements TodosBloc {}

class MockTodosRepository extends Mock implements TodosRepositoryFlutter {}

main() {
  group('FilteredTodosBloc', () {
    test('dispatches TodosUpdated when TodosBloc.state emits TodosLoaded', () {
      final todo = Todo('Wash Dishes', id: '0');
      final TodosRepositoryFlutter todosRepository = MockTodosRepository();
      when(todosRepository.loadTodos()).thenAnswer((_) => Future.value([]));
      when(todosRepository.saveTodos(any)).thenAnswer(
        (_) => Future.value(null),
      );
      final todosBloc = TodosBloc(todosRepository: todosRepository);
      final FilteredTodosBloc filteredTodosBloc = FilteredTodosBloc(
        todosBloc: todosBloc,
      );
      expectLater(
        filteredTodosBloc.state,
        emitsInOrder([
          FilteredTodosLoading(),
          FilteredTodosLoaded([], VisibilityFilter.all),
          FilteredTodosLoaded([todo], VisibilityFilter.all),
        ]),
      );
      todosBloc.dispatch(LoadTodos());
      todosBloc.dispatch(AddTodo(todo));
    });

    test('should update the VisibilityFilter when filter is completed', () {
      final todo = Todo('Wash Dishes');
      final todosBloc = MockTodosBloc();
      when(todosBloc.state).thenAnswer((_) => Stream.empty());
      when(todosBloc.currentState).thenReturn(TodosLoaded([todo]));
      final FilteredTodosBloc filteredTodosBloc = FilteredTodosBloc(
        todosBloc: todosBloc,
      );

      expect(
        filteredTodosBloc.initialState,
        FilteredTodosLoaded([todo], VisibilityFilter.all),
      );

      expectLater(
        filteredTodosBloc.state,
        emitsInOrder([
          FilteredTodosLoaded([todo], VisibilityFilter.all),
          FilteredTodosLoaded([], VisibilityFilter.completed),
        ]),
      );

      filteredTodosBloc.dispatch(UpdateFilter(VisibilityFilter.completed));
    });

    test('should update the VisibilityFilter when filter is active', () {
      final todo = Todo('Wash Dishes');
      final todosBloc = MockTodosBloc();
      when(todosBloc.state).thenAnswer((_) => Stream.empty());
      when(todosBloc.currentState).thenReturn(TodosLoaded([todo]));
      final FilteredTodosBloc filteredTodosBloc = FilteredTodosBloc(
        todosBloc: todosBloc,
      );

      expect(
        filteredTodosBloc.initialState,
        FilteredTodosLoaded([todo], VisibilityFilter.all),
      );

      expectLater(
        filteredTodosBloc.state,
        emitsInOrder([
          FilteredTodosLoaded([todo], VisibilityFilter.all),
          FilteredTodosLoaded([todo], VisibilityFilter.active),
        ]),
      );

      filteredTodosBloc.dispatch(UpdateFilter(VisibilityFilter.active));
    });

    test('dispose does not emit new events', () {
      final todosBloc = MockTodosBloc();
      when(todosBloc.state).thenAnswer((_) => Stream.empty());
      when(todosBloc.currentState).thenReturn(TodosLoaded([]));
      final FilteredTodosBloc filteredTodosBloc = FilteredTodosBloc(
        todosBloc: todosBloc,
      );

      expect(
        filteredTodosBloc.initialState,
        FilteredTodosLoaded([], VisibilityFilter.all),
      );

      expectLater(
        filteredTodosBloc.state,
        emitsInOrder([
          FilteredTodosLoaded([], VisibilityFilter.all),
        ]),
      );

      filteredTodosBloc.dispose();
    });
  });
}
