// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:redux_sample/actions/actions.dart';
import 'package:redux_sample/middleware/store_todos_middleware.dart';
import 'package:redux_sample/models/models.dart';
import 'package:redux_sample/reducers/app_state_reducer.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

class MockTodosRepository extends Mock implements TodosRepository {}

void main() {
  group('Save State Middleware', () {
    test('should load the todos in response to a LoadTodosAction', () {
      final repository = MockTodosRepository();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.loading(),
        middleware: createStoreTodosMiddleware(repository),
      );
      final todos = [
        TodoEntity('Moin', '1', 'Note', false),
      ];

      when(repository.loadTodos()).thenAnswer((_) => Future.value(todos));

      store.dispatch(LoadTodosAction());

      verify(repository.loadTodos());
    });

    test('should save the state on every update action', () {
      final repository = MockTodosRepository();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.loading(),
        middleware: createStoreTodosMiddleware(repository),
      );
      final todo = Todo('Hallo');

      store.dispatch(AddTodoAction(todo));
      store.dispatch(ClearCompletedAction());
      store.dispatch(ToggleAllAction());
      store.dispatch(TodosLoadedAction([Todo('Hi')]));
      store.dispatch(ToggleAllAction());
      store.dispatch(UpdateTodoAction('', Todo('')));
      store.dispatch(DeleteTodoAction(''));

      verify(repository.saveTodos(any)).called(7);
    });
  });
}
