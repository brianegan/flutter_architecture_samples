// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';
import 'package:redux_sample/actions/actions.dart';
import 'package:redux_sample/models/models.dart';
import 'package:redux_sample/reducers/app_state_reducer.dart';
import 'package:redux_sample/selectors/selectors.dart';

void main() {
  group('State Reducer', () {
    test('should add a todo to the list in response to an AddTodoAction', () {
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.loading(),
      );
      final todo = Todo('Hallo');

      store.dispatch(AddTodoAction(todo));

      expect(todosSelector(store.state), [todo]);
    });

    test('should remove from the list in response to a DeleteTodoAction', () {
      final todo = Todo('Hallo');
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(todos: [todo]),
      );

      expect(todosSelector(store.state), [todo]);

      store.dispatch(DeleteTodoAction(todo.id));

      expect(todosSelector(store.state), []);
    });

    test('should update a todo in response to an UpdateTodoAction', () {
      final todo = Todo('Hallo');
      final updatedTodo = todo.copyWith(task: 'Tschüss');
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(todos: [todo]),
      );

      store.dispatch(UpdateTodoAction(todo.id, updatedTodo));

      expect(todosSelector(store.state), [updatedTodo]);
    });

    test('should clear completed todos', () {
      final todo1 = Todo('Hallo');
      final todo2 = Todo('Tschüss', complete: true);
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(todos: [todo1, todo2]),
      );

      expect(todosSelector(store.state), [todo1, todo2]);

      store.dispatch(ClearCompletedAction());

      expect(todosSelector(store.state), [todo1]);
    });

    test('should mark all as completed if some todos are incomplete', () {
      final todo1 = Todo('Hallo');
      final todo2 = Todo('Tschüss', complete: true);
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(todos: [todo1, todo2]),
      );

      expect(todosSelector(store.state), [todo1, todo2]);

      store.dispatch(ToggleAllAction());

      expect(allCompleteSelector(todosSelector(store.state)), isTrue);
    });

    test('should mark all as incomplete if all todos are complete', () {
      final todo1 = Todo('Hallo', complete: true);
      final todo2 = Todo('Tschüss', complete: true);
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(todos: [todo1, todo2]),
      );

      expect(todosSelector(store.state), [todo1, todo2]);

      store.dispatch(ToggleAllAction());

      expect(allCompleteSelector(todosSelector(store.state)), isFalse);
    });

    test('should update the VisibilityFilter', () {
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(activeFilter: VisibilityFilter.active),
      );

      store.dispatch(UpdateFilterAction(VisibilityFilter.completed));

      expect(store.state.activeFilter, VisibilityFilter.completed);
    });

    test('should update the AppTab', () {
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(activeTab: AppTab.todos),
      );

      store.dispatch(UpdateTabAction(AppTab.stats));

      expect(store.state.activeTab, AppTab.stats);
    });
  });
}
