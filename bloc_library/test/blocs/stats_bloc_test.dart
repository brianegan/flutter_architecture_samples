import 'dart:async';

import 'package:bloc_library/blocs/stats/stats.dart';
import 'package:bloc_library/blocs/todos/todos.dart';
import 'package:bloc_library/models/models.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTodosBloc extends MockBloc<TodosEvent, TodosState>
    implements TodosBloc {}

void main() {
  group('StatsBloc', () {
    final todo1 = Todo('Hallo');
    final todo2 = Todo('Hallo2', complete: true);

    blocTest<StatsBloc, StatsState>(
      'should update the stats properly when TodosBloc emits TodosLoaded',
      build: () {
        final todosBloc = MockTodosBloc();
        when(() => todosBloc.state).thenReturn(TodosLoading());
        whenListen(
          todosBloc,
          Stream<TodosState>.fromIterable([TodosLoaded([])]),
        );
        return StatsBloc(todosBloc: todosBloc);
      },
      expect: () => [StatsLoaded(0, 0)],
    );

    blocTest<StatsBloc, StatsState>(
      'should update the stats properly when Todos are empty',
      build: () {
        final todosBloc = MockTodosBloc();
        when(() => todosBloc.state).thenReturn(TodosLoading());
        return StatsBloc(todosBloc: todosBloc);
      },
      act: (StatsBloc bloc) async => bloc.add(UpdateStats([])),
      expect: () => [StatsLoaded(0, 0)],
    );

    blocTest<StatsBloc, StatsState>(
      'should update the stats properly when Todos contains one active todo',
      build: () {
        final todosBloc = MockTodosBloc();
        when(() => todosBloc.state).thenReturn(TodosLoading());
        return StatsBloc(todosBloc: todosBloc);
      },
      act: (StatsBloc bloc) async => bloc.add(UpdateStats([todo1])),
      expect: () => [StatsLoaded(1, 0)],
    );

    blocTest<StatsBloc, StatsState>(
      'should update the stats properly when Todos contains one active todo and one completed todo',
      build: () {
        final todosBloc = MockTodosBloc();
        when(() => todosBloc.state).thenReturn(TodosLoading());
        return StatsBloc(todosBloc: todosBloc);
      },
      act: (StatsBloc bloc) async => bloc.add(UpdateStats([todo1, todo2])),
      expect: () => [StatsLoaded(1, 1)],
    );
  });
}
