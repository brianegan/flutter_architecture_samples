// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_library/blocs/stats/stats.dart';
import 'package:bloc_library/blocs/todos/todos.dart';
import 'package:bloc_library/models/models.dart';

class MockTodosBloc extends Mock implements TodosBloc {}

main() {
  group('StatsBloc', () {
    final todo1 = Todo("Hallo");
    final todo2 = Todo("Hallo2", complete: true);
    TodosBloc todosBloc;
    StatsBloc statsBloc;

    setUp(() {
      todosBloc = MockTodosBloc();
      when(todosBloc.state).thenAnswer((_) => Stream.empty());
      statsBloc = StatsBloc(todosBloc: todosBloc);
    });

    test('should update the stats properly when TodosBloc emits TodosLoaded',
        () {
      todosBloc = MockTodosBloc();
      when(todosBloc.state)
          .thenAnswer((_) => Stream.fromIterable([TodosLoaded([])]));
      statsBloc = StatsBloc(todosBloc: todosBloc);
      expect(statsBloc.initialState, StatsLoading());
      expectLater(
        statsBloc.state,
        emitsInOrder([
          StatsLoading(),
          StatsLoaded(0, 0),
        ]),
      );

      statsBloc.dispatch(UpdateStats([]));
    });

    test('should update the stats properly when Todos are empty', () {
      expect(statsBloc.initialState, StatsLoading());
      expectLater(
        statsBloc.state,
        emitsInOrder([
          StatsLoading(),
          StatsLoaded(0, 0),
        ]),
      );

      statsBloc.dispatch(UpdateStats([]));
    });

    test('should update the stats properly when Todos contains one active todo',
        () {
      expectLater(
        statsBloc.state,
        emitsInOrder([
          StatsLoading(),
          StatsLoaded(1, 0),
        ]),
      );

      statsBloc.dispatch(UpdateStats([todo1]));
    });

    test('should update the stats properly when Todos contains one active todo',
        () {
      expectLater(
        statsBloc.state,
        emitsInOrder([
          StatsLoading(),
          StatsLoaded(1, 1),
        ]),
      );

      statsBloc.dispatch(UpdateStats([todo1, todo2]));
    });

    test('should not emit new events when dispose is called', () {
      expectLater(
        statsBloc.state,
        emitsInOrder([
          StatsLoading(),
        ]),
      );

      statsBloc.dispose();
    });
  });
}
