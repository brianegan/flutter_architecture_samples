// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved. 
// Use of this source code is governed by the MIT license that can be found 
// in the LICENSE file.

import 'package:redux/redux.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:fire_redux_sample/actions/actions.dart';
import 'package:fire_redux_sample/reducers/app_state_reducer.dart';
import 'package:fire_redux_sample/middleware/store_todos_middleware.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fire_redux_sample/selectors/selectors.dart';
import 'firestore_services_mock.dart';

main() {
  group('verify all actions with Middleware', () {
    test('AddTodoAction: should have 3 todos, 2 active and 1 completed', () {
      final firestoreServices = new MockFirestoreServices();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState.loading(),
        middleware: createStoreTodosMiddleware(firestoreServices),
      );
      final todo1 = new Todo("Hallo", id: '1');
      final todo2 = new Todo("Bye", complete: true);
      final todo3 = new Todo("Uncertain");

      store.dispatch(new AddTodoAction(todo1));
      store.dispatch(new AddTodoAction(todo2));
      store.dispatch(new AddTodoAction(todo3));
      expect(todosSelector(store.state).length, 3);
      expect(numActiveSelector(todosSelector(store.state)), 2);
      expect(numCompletedSelector(todosSelector(store.state)), 1);
    });

    test(
        'ClearCompletedAction: '
        'should have 2 todos, 2 active and 0 completed', () {
      final firestoreServices = new MockFirestoreServices();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState.loading(),
        middleware: createStoreTodosMiddleware(firestoreServices),
      );
      final todo1 = new Todo("Hallo", id: '1');
      final todo2 = new Todo("Bye", complete: true);
      final todo3 = new Todo("Uncertain");

      store.dispatch(new AddTodoAction(todo1));
      store.dispatch(new AddTodoAction(todo2));
      store.dispatch(new AddTodoAction(todo3));
      store.dispatch(new ClearCompletedAction());
      expect(todosSelector(store.state).length, 2);
      expect(numActiveSelector(todosSelector(store.state)), 2);
      expect(numCompletedSelector(todosSelector(store.state)), 0);
    });

    test(
        'ToggleAllAction(false): '
        'should have 3 todos, 0 active and 3 completed', () {
      final firestoreServices = new MockFirestoreServices();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState.loading(),
        middleware: createStoreTodosMiddleware(firestoreServices),
      );
      final todo1 = new Todo("Hallo", id: '1');
      final todo2 = new Todo("Bye", complete: true);
      final todo3 = new Todo("Uncertain");

      store.dispatch(new AddTodoAction(todo1));
      store.dispatch(new AddTodoAction(todo2));
      store.dispatch(new AddTodoAction(todo3));
      store.dispatch(new ToggleAllAction(false));
      expect(todosSelector(store.state).length, 3);
      expect(numActiveSelector(todosSelector(store.state)), 0);
      expect(numCompletedSelector(todosSelector(store.state)), 3);
    });

    test(
        'ToggleAllAction(true): '
        'should have 3 todos, 3 active and 0 completed', () {
      final firestoreServices = new MockFirestoreServices();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState.loading(),
        middleware: createStoreTodosMiddleware(firestoreServices),
      );
      final todo1 = new Todo("Hallo", id: '1');
      final todo2 = new Todo("Bye", complete: true);
      final todo3 = new Todo("Uncertain");

      store.dispatch(new AddTodoAction(todo1));
      store.dispatch(new AddTodoAction(todo2));
      store.dispatch(new AddTodoAction(todo3));
      store.dispatch(new ToggleAllAction(true));
      expect(todosSelector(store.state).length, 3);
      expect(numActiveSelector(todosSelector(store.state)), 3);
      expect(numCompletedSelector(todosSelector(store.state)), 0);
    });

    test(
        'UpdateTodoAction: '
        'should have 3 todos, 1 active and 2 completed', () {
      final firestoreServices = new MockFirestoreServices();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState.loading(),
        middleware: createStoreTodosMiddleware(firestoreServices),
      );
      final todo1 = new Todo("Hallo", id: '1');
      final todo2 = new Todo("Bye", complete: true);
      final todo3 = new Todo("Uncertain");

      store.dispatch(new AddTodoAction(todo1));
      store.dispatch(new AddTodoAction(todo2));
      store.dispatch(new AddTodoAction(todo3));

      store.dispatch(new UpdateTodoAction(
          '1', new Todo("Hallo & Welcome", complete: true, id: '1')));
      expect(todosSelector(store.state).length, 3);
      expect(numActiveSelector(todosSelector(store.state)), 1);
      expect(numCompletedSelector(todosSelector(store.state)), 2);
    });

    test(
        'DeleteTodoAction: '
        'should have 2 todos, 1 active and 1 completed', () {
      final firestoreServices = new MockFirestoreServices();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState.loading(),
        middleware: createStoreTodosMiddleware(firestoreServices),
      );
      final todo1 = new Todo("Hallo", id: '1');
      final todo2 = new Todo("Bye", complete: true);
      final todo3 = new Todo("Uncertain");

      store.dispatch(new AddTodoAction(todo1));
      store.dispatch(new AddTodoAction(todo2));
      store.dispatch(new AddTodoAction(todo3));

      store.dispatch(new DeleteTodoAction('1'));
      expect(todosSelector(store.state).length, 2);
      expect(numActiveSelector(todosSelector(store.state)), 1);
      expect(numCompletedSelector(todosSelector(store.state)), 1);
    });
  });
}
