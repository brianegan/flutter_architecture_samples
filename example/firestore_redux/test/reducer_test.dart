// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:redux/redux.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:fire_redux_sample/actions/actions.dart';
import 'package:fire_redux_sample/reducers/app_state_reducer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fire_redux_sample/selectors/selectors.dart';

main() {
  group('State Reducer', () {
    test('should load todos into store', () {
      final todo1 = new Todo('a');
      final todo2 = new Todo('b');
      final todo3 = new Todo('c', complete: true);
      final todos = [
        todo1,
        todo2,
        todo3,
      ];
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState.loading(),
      );

      expect(todosSelector(store.state), []);

      store.dispatch(new LoadTodosAction(todos));

      expect(todosSelector(store.state), todos);
    });

    test('should update the VisibilityFilter', () {
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState(activeFilter: VisibilityFilter.active),
      );

      store.dispatch(new UpdateFilterAction(VisibilityFilter.completed));

      expect(store.state.activeFilter, VisibilityFilter.completed);
    });

    test('should update the AppTab', () {
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState(activeTab: AppTab.todos),
      );

      store.dispatch(new UpdateTabAction(AppTab.stats));

      expect(store.state.activeTab, AppTab.stats);
    });
  });
}
