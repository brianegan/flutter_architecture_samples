// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_library/blocs/stats/stats.dart';
import 'package:bloc_library/blocs/todos/todos.dart';
import 'package:bloc_library/models/models.dart';

class MockTodosBloc extends MockBloc<TodosEvent, TodosState>
    implements TodosBloc {}

void main() {
  group('StatsBloc', () {
    final todo1 = Todo('Hallo');
    final todo2 = Todo('Hallo2', complete: true);
    TodosBloc todosBloc;
    StatsBloc statsBloc;

    setUp(() {
      todosBloc = MockTodosBloc();
      statsBloc = StatsBloc(todosBloc: todosBloc);
    });

    blocTest<StatsBloc, StatsEvent, StatsState>(
      'should update the stats properly when TodosBloc emits TodosLoaded',
      build: () {
        todosBloc = MockTodosBloc();
        whenListen(
          todosBloc,
          Stream<TodosState>.fromIterable([TodosLoaded([])]),
        );
        return StatsBloc(todosBloc: todosBloc);
      },
      act: (StatsBloc bloc) async => bloc.add(UpdateStats([])),
      expect: <StatsState>[
        StatsLoading(),
        StatsLoaded(0, 0),
      ],
    );

    blocTest<StatsBloc, StatsEvent, StatsState>(
      'should update the stats properly when Todos are empty',
      build: () => statsBloc,
      act: (StatsBloc bloc) async => bloc.add(UpdateStats([])),
      expect: <StatsState>[
        StatsLoading(),
        StatsLoaded(0, 0),
      ],
    );

    blocTest<StatsBloc, StatsEvent, StatsState>(
      'should update the stats properly when Todos contains one active todo',
      build: () => statsBloc,
      act: (StatsBloc bloc) async => bloc.add(UpdateStats([todo1])),
      expect: <StatsState>[
        StatsLoading(),
        StatsLoaded(1, 0),
      ],
    );

    blocTest<StatsBloc, StatsEvent, StatsState>(
      'should update the stats properly when Todos contains one active todo and one completed todo',
      build: () => statsBloc,
      act: (StatsBloc bloc) async => bloc.add(UpdateStats([todo1, todo2])),
      expect: <StatsState>[
        StatsLoading(),
        StatsLoaded(1, 1),
      ],
    );
  });
}
