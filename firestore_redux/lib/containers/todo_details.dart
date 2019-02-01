// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:fire_redux_sample/actions/actions.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:fire_redux_sample/presentation/details_screen.dart';
import 'package:fire_redux_sample/selectors/selectors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class TodoDetails extends StatelessWidget {
  final String id;

  TodoDetails({Key key, @required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      ignoreChange: (state) => todoSelector(state.todos, id).isNotPresent,
      converter: (Store<AppState> store) {
        return _ViewModel.from(store, id);
      },
      builder: (context, vm) {
        return DetailsScreen(
          todo: vm.todo,
          onDelete: vm.onDelete,
          toggleCompleted: vm.toggleCompleted,
        );
      },
    );
  }
}

class _ViewModel {
  final Todo todo;
  final Function onDelete;
  final Function(bool) toggleCompleted;

  _ViewModel({
    @required this.todo,
    @required this.onDelete,
    @required this.toggleCompleted,
  });

  factory _ViewModel.from(Store<AppState> store, String id) {
    final todo = todoSelector(todosSelector(store.state), id).value;

    return _ViewModel(
      todo: todo,
      onDelete: () => store.dispatch(DeleteTodoAction(todo.id)),
      toggleCompleted: (isComplete) {
        store.dispatch(UpdateTodoAction(
          todo.id,
          todo.copyWith(complete: isComplete),
        ));
      },
    );
  }
}
