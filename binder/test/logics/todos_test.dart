// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:binder/binder.dart';
import 'package:binder_sample/logics/todos.dart';
import 'package:binder_sample/models.dart';
import 'package:binder_sample/refs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

class MockScope extends Mock implements Scope {}

class MockTodosRepository extends Mock implements TodosRepository {}

void main() {
  TodosLogic todosLogic;
  Scope mockScope;
  TodosRepository mockTodosRepository;

  setUp(() {
    mockScope = MockScope();
    mockTodosRepository = MockTodosRepository();
    todosLogic = TodosLogic(mockScope);

    when(mockScope.use(todosRepositoryRef)).thenReturn(mockTodosRepository);
  });

  group('TodosLogic', () {
    test('should correctly update todosRef and save todos when add is called',
        () async {
      when(mockScope.read(todosRef)).thenReturn(<Todo>[]);
      final todo = Todo('hello', complete: false);
      await todosLogic.add(todo);

      verify(mockScope.write(todosRef, [todo]));
      verify(mockScope.read(todosRef)).called(2);
      verify(mockTodosRepository.saveTodos(any));
    });

    test(
        'should correctly update todosRef and save todos when delete is called',
        () async {
      final todo = Todo('hello', complete: false);
      when(mockScope.read(todosRef)).thenReturn(<Todo>[todo]);
      await todosLogic.delete(todo);

      verify(mockScope.write(todosRef, []));
      verify(mockScope.read(todosRef)).called(2);
      verify(mockTodosRepository.saveTodos(any));
    });

    test('should correctly update todosRef and save todos when edit is called',
        () async {
      final todo = Todo('hello', complete: false);
      when(mockScope.read(todosRef)).thenReturn(<Todo>[todo]);

      final newTodo = todo.copyWith(task: 'hi');
      await todosLogic.edit(newTodo);

      verify(mockScope.write(todosRef, [newTodo]));
      verify(mockScope.read(todosRef)).called(2);
      verify(mockTodosRepository.saveTodos(any));
    });

    test('should correctly init todosRef when init is called', () async {
      when(mockTodosRepository.loadTodos()).thenAnswer(
        (_) async => [
          TodoEntity(
            'todo',
            'id',
            'note',
            false,
          )
        ],
      );
      await todosLogic.init();

      verify(mockScope.write(todosRef, [
        Todo(
          'todo',
          id: 'id',
          note: 'note',
          complete: false,
        )
      ]));
      verify(mockScope.write(isLoadedRef, true));
    });
  });
}
