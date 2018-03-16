// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved. 
// Use of this source code is governed by the MIT license that can be found 
// in the LICENSE file.

import 'package:redux/redux.dart';
import 'package:fire_redux_sample/actions/actions.dart';
import 'package:fire_redux_sample/models/models.dart';

final todosReducer = combineTypedReducers<List<Todo>>([
  new ReducerBinding<List<Todo>, LoadTodosAction>(_setLoadedTodos),
]);

List<Todo> _setLoadedTodos(List<Todo> todos, LoadTodosAction action) {
  return action.todos;
}
