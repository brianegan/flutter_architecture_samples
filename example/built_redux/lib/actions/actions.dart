// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

library actions;

import 'package:built_redux/built_redux.dart';
import 'package:built_redux_sample/models/models.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'actions.g.dart';

abstract class AppActions extends ReduxActions {
  ActionDispatcher<Todo> addTodoAction;
  ActionDispatcher<Null> clearCompletedAction;
  ActionDispatcher<String> deleteTodoAction;
  ActionDispatcher<Null> fetchTodosAction;
  ActionDispatcher<Null> toggleAllAction;
  ActionDispatcher<List<Todo>> loadTodosSuccess;
  ActionDispatcher<Object> loadTodosFailure;
  ActionDispatcher<VisibilityFilter> updateFilterAction;
  ActionDispatcher<AppTab> updateTabAction;
  ActionDispatcher<UpdateTodoActionPayload> updateTodoAction;

  AppActions._();

  factory AppActions() => _$AppActions();
}

abstract class UpdateTodoActionPayload
    implements Built<UpdateTodoActionPayload, UpdateTodoActionPayloadBuilder> {
  static Serializer<UpdateTodoActionPayload> get serializer =>
      _$updateTodoActionPayloadSerializer;

  String get id;

  Todo get updatedTodo;

  UpdateTodoActionPayload._();

  factory UpdateTodoActionPayload(String id, Todo updatedTodo) =>
      _$UpdateTodoActionPayload._(
        id: id,
        updatedTodo: updatedTodo,
      );
}
