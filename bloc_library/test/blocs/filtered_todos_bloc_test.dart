import 'dart:async';

import 'package:bloc_library/blocs/blocs.dart';
import 'package:bloc_library/models/models.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

class MockTodosBloc extends MockBloc<TodosEvent, TodosState>
    implements TodosBloc {}

class MockTodosRepository extends Mock implements LocalStorageRepository {}

void main() {
  group('$FilteredTodosBloc', () {
    blocTest<FilteredTodosBloc, FilteredTodosState>(
      'adds TodosUpdated when TodosBloc.state emits TodosLoaded',
      build: () {
        final todosBloc = MockTodosBloc();
        when(
          () => todosBloc.state,
        ).thenReturn(TodosLoaded([Todo('Wash Dishes', id: '0')]));
        whenListen(
          todosBloc,
          Stream<TodosState>.fromIterable([
            TodosLoaded([Todo('Wash Dishes', id: '0')]),
          ]),
        );
        return FilteredTodosBloc(todosBloc: todosBloc);
      },
      expect: () => [
        FilteredTodosLoaded([
          Todo('Wash Dishes', id: '0'),
        ], VisibilityFilter.all),
      ],
    );

    blocTest<FilteredTodosBloc, FilteredTodosState>(
      'should update the VisibilityFilter when filter is active',
      build: () {
        final todosBloc = MockTodosBloc();
        when(
          () => todosBloc.state,
        ).thenReturn(TodosLoaded([Todo('Wash Dishes', id: '0')]));
        return FilteredTodosBloc(todosBloc: todosBloc);
      },
      act: (FilteredTodosBloc bloc) async =>
          bloc.add(UpdateFilter(VisibilityFilter.active)),
      expect: () => [
        FilteredTodosLoaded([
          Todo('Wash Dishes', id: '0'),
        ], VisibilityFilter.active),
      ],
    );

    blocTest<FilteredTodosBloc, FilteredTodosState>(
      'should update the VisibilityFilter when filter is completed',
      build: () {
        final todosBloc = MockTodosBloc();
        when(
          () => todosBloc.state,
        ).thenReturn(TodosLoaded([Todo('Wash Dishes', id: '0')]));
        return FilteredTodosBloc(todosBloc: todosBloc);
      },
      act: (FilteredTodosBloc bloc) async =>
          bloc.add(UpdateFilter(VisibilityFilter.completed)),
      expect: () => [FilteredTodosLoaded([], VisibilityFilter.completed)],
    );
  });
}
