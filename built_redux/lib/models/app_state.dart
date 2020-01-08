// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

library app_state;

import 'package:built_collection/built_collection.dart';
import 'package:built_redux_sample/models/app_tab.dart';
import 'package:built_redux_sample/models/todo.dart';
import 'package:built_redux_sample/models/visibility_filter.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:todos_app_core/todos_app_core.dart';

part 'app_state.g.dart';

abstract class AppState implements Built<AppState, AppStateBuilder> {
  static Serializer<AppState> get serializer => _$appStateSerializer;

  bool get isLoading;

  BuiltList<Todo> get todos;

  AppTab get activeTab;

  VisibilityFilter get activeFilter;

  AppState._();

  factory AppState([void Function(AppStateBuilder b) updates]) =>
      _$AppState((b) => b
        ..isLoading = false
        ..todos = ListBuilder<Todo>([])
        ..activeTab = AppTab.todos
        ..activeFilter = VisibilityFilter.all
        ..update(updates));

  factory AppState.loading() => AppState((b) => b..isLoading = true);

  factory AppState.fromTodos(List<Todo> todos) =>
      AppState((b) => b..todos = ListBuilder<Todo>(todos));

  /// [numCompletedSelector] memoizes and returns the number of complete todos.
  @memoized
  int get numCompletedSelector =>
      todos.fold(0, (sum, todo) => todo.complete ? ++sum : sum);

  /// [numActiveSelector] returns and memoizes the number of active todos.
  /// Note it is computed using numCompletedSelector. Since `numCompletedSelector` is memoized, this is
  /// cheaper than iterating over all todos again by doing todos.fold(0, (sum, todo) => !todo.complete ? ++sum : sum);
  @memoized
  int get numActiveSelector => todos.length - numCompletedSelector;

  /// [allCompleteSelector] returns and memoizes a boolean value which is true if all todos are complete.
  /// Note it is computed using numCompletedSelector. Since `numCompletedSelector` is memoized, this is
  /// cheaper than iterating over all todos again by doing todos.every((t) => t.completed);
  @memoized
  bool get allCompleteSelector => numCompletedSelector == todos.length;

  @memoized
  List<Todo> get filteredTodosSelector => todos.where((todo) {
        switch (activeFilter) {
          case VisibilityFilter.active:
            return !todo.complete;
          case VisibilityFilter.completed:
            return todo.complete;
          case VisibilityFilter.all:
          default:
            return true;
        }
      }).toList();

  Optional<Todo> todoSelector(String id) {
    try {
      return Optional.of(todos.firstWhere((todo) => todo.id == id));
    } catch (e) {
      return Optional.absent();
    }
  }
}
