// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:binder/binder.dart';
import 'package:binder_sample/logics/home_screen.dart';
import 'package:binder_sample/logics/todos.dart';
import 'package:binder_sample/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockScope extends Mock implements Scope {}

class MockTodosLogic extends Mock implements TodosLogic {}

void main() {
  HomeScreenLogic homeScreenLogic;
  Scope mockScope;
  TodosLogic mockTodosLogic;

  setUp(() {
    mockScope = MockScope();
    mockTodosLogic = MockTodosLogic();
    homeScreenLogic = HomeScreenLogic(mockScope);

    when(mockScope.use(todosLogicRef)).thenReturn(mockTodosLogic);
  });

  group('HomeScreenLogic', () {
    test('clearCompleted() should correctly delete completed todos', () async {
      when(mockTodosLogic.delete(any)).thenAnswer((_) async {});
      when(mockScope.read(todosRef)).thenReturn([
        Todo('t1', id: '1', complete: true),
        Todo('t2', id: '2', complete: false),
        Todo('t3', id: '3', complete: true),
        Todo('t4', id: '4', complete: false),
        Todo('t5', id: '5', complete: false),
      ]);
      await homeScreenLogic.clearCompleted();

      final captured = verify(mockTodosLogic.delete(captureAny)).captured;
      final capturedIds = captured.map((e) => e.id).toList();
      expect(capturedIds, ['1', '3']);
    });

    test('toggleAll() should make all todos completed if one is not completed',
        () async {
      when(mockTodosLogic.edit(any)).thenAnswer((_) async {});
      when(mockScope.read(todosRef)).thenReturn([
        Todo('t1', id: '1', complete: true),
        Todo('t2', id: '2', complete: false),
        Todo('t3', id: '3', complete: true),
      ]);
      await homeScreenLogic.toggleAll();

      final captured = verify(mockTodosLogic.edit(captureAny)).captured;
      final capturedIds = captured.map((e) => e.complete).toList();
      expect(capturedIds, [true, true, true]);
    });

    test(
        'toggleAll() should make all todos not completed if all are  completed',
        () async {
      when(mockTodosLogic.edit(any)).thenAnswer((_) async {});
      when(mockScope.read(todosRef)).thenReturn([
        Todo('t1', id: '1', complete: true),
        Todo('t2', id: '2', complete: true),
        Todo('t3', id: '3', complete: true),
      ]);
      await homeScreenLogic.toggleAll();

      final captured = verify(mockTodosLogic.edit(captureAny)).captured;
      final capturedIds = captured.map((e) => e.complete).toList();
      expect(capturedIds, [false, false, false]);
    });
  });
}
