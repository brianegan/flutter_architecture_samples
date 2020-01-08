// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:built_redux/built_redux.dart';
import 'package:built_redux_sample/actions/actions.dart';
import 'package:built_redux_sample/models/models.dart';
import 'package:built_redux_sample/reducers/reducers.dart';
import 'package:test/test.dart';

void main() {
  group('State Reducer', () {
    test('should add a todo to the list in response to an AddTodoAction', () {
      final todo = Todo('Hallo');
      final store = Store<AppState, AppStateBuilder, AppActions>(
        reducerBuilder.build(),
        AppState(),
        AppActions(),
      );

      store.actions.addTodoAction(todo);

      expect(store.state.todos, [todo]);
    });

    test('should remove from the list in response to a DeleteTodoAction', () {
      final todo = Todo('Hallo');
      final store = Store<AppState, AppStateBuilder, AppActions>(
        reducerBuilder.build(),
        AppState.fromTodos([todo]),
        AppActions(),
      );

      expect(store.state.todos, [todo]);

      store.actions.deleteTodoAction(todo.id);

      expect(store.state.todos, []);
    });

    test('should update a todo in response to an UpdateTodoAction', () {
      final todo = Todo('Hallo');
      final updatedTodo = todo.rebuild((b) => b.task = 'Tschuss');
      final store = Store<AppState, AppStateBuilder, AppActions>(
        reducerBuilder.build(),
        AppState.fromTodos([todo]),
        AppActions(),
      );

      store.actions
          .updateTodoAction(UpdateTodoActionPayload(todo.id, updatedTodo));

      expect(store.state.todos, [updatedTodo]);
    });

    test('should clear completed todos', () {
      final todo1 = Todo('Hallo');
      final todo2 = Todo.builder(
        (b) => b
          ..task = 'Tschüss'
          ..complete = true,
      );
      final store = Store<AppState, AppStateBuilder, AppActions>(
        reducerBuilder.build(),
        AppState.fromTodos([todo1, todo2]),
        AppActions(),
      );

      expect(store.state.todos, [todo1, todo2]);

      store.actions.clearCompletedAction();

      expect(store.state.todos, [todo1]);
    });

    test('should mark all as completed if some todos are incomplete', () {
      final todo1 = Todo('Hallo');
      final todo2 = Todo.builder(
        (b) => b
          ..task = 'Tschüss'
          ..complete = true,
      );
      final store = Store<AppState, AppStateBuilder, AppActions>(
        reducerBuilder.build(),
        AppState.fromTodos([todo1, todo2]),
        AppActions(),
      );

      expect(store.state.todos, [todo1, todo2]);

      store.actions.toggleAllAction();

      expect(store.state.allCompleteSelector, isTrue);
    });

    test('should mark all as incomplete if all todos are complete', () {
      final todo1 = Todo.builder(
        (b) => b
          ..task = 'Hallo'
          ..complete = true,
      );
      final todo2 = Todo.builder(
        (b) => b
          ..task = 'Tschüss'
          ..complete = true,
      );
      final store = Store<AppState, AppStateBuilder, AppActions>(
        reducerBuilder.build(),
        AppState.fromTodos([todo1, todo2]),
        AppActions(),
      );

      expect(store.state.todos, [todo1, todo2]);

      store.actions.toggleAllAction();

      expect(store.state.allCompleteSelector, isFalse);
      expect(store.state.todos.every((todo) => !todo.complete), isTrue);
    });

    test('should update the VisibilityFilter', () {
      final store = Store<AppState, AppStateBuilder, AppActions>(
        reducerBuilder.build(),
        AppState(),
        AppActions(),
      );

      store.actions.updateFilterAction(VisibilityFilter.completed);

      expect(store.state.activeFilter, VisibilityFilter.completed);
    });

    test('should update the AppTab', () {
      final store = Store<AppState, AppStateBuilder, AppActions>(
        reducerBuilder.build(),
        AppState(),
        AppActions(),
      );

      store.actions.updateTabAction(AppTab.stats);

      expect(store.state.activeTab, AppTab.stats);
    });
  });
}
