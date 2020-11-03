// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:binder/binder.dart';
import 'package:binder_sample/logics/add_edit_screen.dart';
import 'package:binder_sample/logics/todos.dart';
import 'package:binder_sample/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockScope extends Mock implements Scope {}

class MockTodosLogic extends Mock implements TodosLogic {}

void main() {
  AddEditScreenLogic addEditScreenLogic;
  Scope mockScope;
  TodosLogic mockTodosLogic;

  setUp(() {
    mockScope = MockScope();
    mockTodosLogic = MockTodosLogic();
    addEditScreenLogic = AddEditScreenLogic(mockScope);

    when(mockScope.use(todosLogicRef)).thenReturn(mockTodosLogic);
  });

  group('AddEditScreenLogic', () {
    test('put() should call TodosLogic.edit() when todo is not null', () async {
      when(mockScope.read(noteRef)).thenReturn('my_note');
      when(mockScope.read(taskRef)).thenReturn('my_task');
      final todo = Todo('hello', complete: true, id: 'id');
      await addEditScreenLogic.put(todo);

      verify(mockTodosLogic.edit(Todo(
        'my_task',
        note: 'my_note',
        complete: true,
        id: 'id',
      )));
    });

    test('put() should call TodosLogic.add() when todo is null', () async {
      when(mockScope.read(noteRef)).thenReturn('my_note');
      when(mockScope.read(taskRef)).thenReturn('my_task');
      await addEditScreenLogic.put(null);

      final captured = verify(mockTodosLogic.add(captureAny)).captured;
      final todo = captured.first as Todo;
      expect(todo.task, 'my_task');
      expect(todo.note, 'my_note');
      expect(todo.complete, false);
    });
  });
}
