// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_library/blocs/todos/todos.dart';
import 'package:bloc_library/models/models.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

class MockTodosRepository extends Mock implements LocalStorageRepository {}

void main() {
  group('TodosBloc', () {
    LocalStorageRepository todosRepository;
    TodosBloc todosBloc;

    setUp(() {
      todosRepository = MockTodosRepository();
      when(todosRepository.loadTodos()).thenAnswer((_) => Future.value([]));
      todosBloc = TodosBloc(todosRepository: todosRepository);
    });

    blocTest<TodosBloc, TodosEvent, TodosState>(
      'should emit TodosNotLoaded if repository throws',
      build: () {
        when(todosRepository.loadTodos()).thenThrow(Exception('oops'));
        return todosBloc;
      },
      act: (TodosBloc bloc) async => bloc.add(LoadTodos()),
      expect: <TodosState>[
        TodosLoading(),
        TodosNotLoaded(),
      ],
    );

    blocTest<TodosBloc, TodosEvent, TodosState>(
      'should add a todo to the list in response to an AddTodo Event',
      build: () => todosBloc,
      act: (TodosBloc bloc) async =>
          bloc..add(LoadTodos())..add(AddTodo(Todo('Hallo', id: '0'))),
      expect: <TodosState>[
        TodosLoading(),
        TodosLoaded([]),
        TodosLoaded([Todo('Hallo', id: '0')]),
      ],
    );

    blocTest<TodosBloc, TodosEvent, TodosState>(
      'should remove from the list in response to a DeleteTodo Event',
      build: () {
        when(todosRepository.loadTodos()).thenAnswer((_) => Future.value([]));
        return todosBloc;
      },
      act: (TodosBloc bloc) async {
        final todo = Todo('Hallo', id: '0');
        bloc..add(LoadTodos())..add(AddTodo(todo))..add(DeleteTodo(todo));
      },
      expect: <TodosState>[
        TodosLoading(),
        TodosLoaded([]),
        TodosLoaded([Todo('Hallo', id: '0')]),
        TodosLoaded([]),
      ],
    );

    blocTest<TodosBloc, TodosEvent, TodosState>(
      'should update a todo in response to an UpdateTodoAction',
      build: () => todosBloc,
      act: (TodosBloc bloc) async {
        final todo = Todo('Hallo', id: '0');
        bloc
          ..add(LoadTodos())
          ..add(AddTodo(todo))
          ..add(UpdateTodo(todo.copyWith(task: 'Tschüss')));
      },
      expect: <TodosState>[
        TodosLoading(),
        TodosLoaded([]),
        TodosLoaded([Todo('Hallo', id: '0')]),
        TodosLoaded([Todo('Tschüss', id: '0')]),
      ],
    );

    blocTest<TodosBloc, TodosEvent, TodosState>(
      'should clear completed todos',
      build: () => todosBloc,
      act: (TodosBloc bloc) async {
        final todo1 = Todo('Hallo', id: '0');
        final todo2 = Todo('Tschüss', complete: true, id: '1');
        bloc
          ..add(LoadTodos())
          ..add(AddTodo(todo1))
          ..add(AddTodo(todo2))
          ..add(ClearCompleted());
        ;
      },
      expect: <TodosState>[
        TodosLoading(),
        TodosLoaded([]),
        TodosLoaded([Todo('Hallo', id: '0')]),
        TodosLoaded([
          Todo('Hallo', id: '0'),
          Todo('Tschüss', id: '1', complete: true),
        ]),
        TodosLoaded([Todo('Hallo', id: '0')]),
      ],
    );

    blocTest<TodosBloc, TodosEvent, TodosState>(
      'should mark all as completed if some todos are incomplete',
      build: () => todosBloc,
      act: (TodosBloc bloc) async {
        final todo1 = Todo('Hallo', id: '0');
        final todo2 = Todo('Tschüss', complete: true, id: '1');
        bloc
          ..add(LoadTodos())
          ..add(AddTodo(todo1))
          ..add(AddTodo(todo2))
          ..add(ToggleAll());
        ;
      },
      expect: <TodosState>[
        TodosLoading(),
        TodosLoaded([]),
        TodosLoaded([Todo('Hallo', id: '0')]),
        TodosLoaded([
          Todo('Hallo', id: '0'),
          Todo('Tschüss', id: '1', complete: true),
        ]),
        TodosLoaded([
          Todo('Hallo', id: '0', complete: true),
          Todo('Tschüss', id: '1', complete: true),
        ]),
      ],
    );

    blocTest<TodosBloc, TodosEvent, TodosState>(
      'should mark all as incomplete if all todos are complete',
      build: () => todosBloc,
      act: (TodosBloc bloc) async {
        final todo1 = Todo('Hallo', complete: true, id: '0');
        final todo2 = Todo('Tschüss', complete: true, id: '1');
        bloc
          ..add(LoadTodos())
          ..add(AddTodo(todo1))
          ..add(AddTodo(todo2))
          ..add(ToggleAll());
        ;
      },
      expect: <TodosState>[
        TodosLoading(),
        TodosLoaded([]),
        TodosLoaded([Todo('Hallo', id: '0', complete: true)]),
        TodosLoaded([
          Todo('Hallo', id: '0', complete: true),
          Todo('Tschüss', id: '1', complete: true),
        ]),
        TodosLoaded([
          Todo('Hallo', id: '0'),
          Todo('Tschüss', id: '1'),
        ]),
      ],
    );
  });
}
