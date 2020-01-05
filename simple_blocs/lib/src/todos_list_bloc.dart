// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:simple_blocs/src/models/models.dart';
import 'package:simple_blocs/src/todos_interactor.dart';

class TodosListBloc {
  final TodosInteractor _interactor;
  final _visibilityFilterController = BehaviorSubject<VisibilityFilter>.seeded(
    VisibilityFilter.all,
    sync: true,
  );

  TodosListBloc(TodosInteractor interactor) : _interactor = interactor;

  // Inputs
  void addTodo(Todo todo) => _interactor.addNewTodo(todo);

  void deleteTodo(String id) => _interactor.deleteTodo(id);

  void updateFilter(VisibilityFilter visibilityFilter) =>
      _visibilityFilterController.add(visibilityFilter);

  void clearCompleted() => _interactor.clearCompleted();

  void toggleAll() => _interactor.toggleAll();

  void updateTodo(Todo todo) => _interactor.updateTodo(todo);

  // Outputs
  Stream<VisibilityFilter> get activeFilter =>
      _visibilityFilterController.stream;

  Stream<bool> get allComplete => _interactor.allComplete;

  Stream<bool> get hasCompletedTodos => _interactor.hasCompletedTodos;

  Stream<List<Todo>> get visibleTodos =>
      Rx.combineLatest2<List<Todo>, VisibilityFilter, List<Todo>>(
        _interactor.todos,
        _visibilityFilterController.stream,
        _filterTodos,
      );

  static List<Todo> _filterTodos(List<Todo> todos, VisibilityFilter filter) {
    return todos.where((todo) {
      switch (filter) {
        case VisibilityFilter.active:
          return !todo.complete;
        case VisibilityFilter.completed:
          return todo.complete;
        case VisibilityFilter.all:
        default:
          return true;
      }
    }).toList();
  }

  // This method should close down all sinks and cancel all stream
  // subscriptions. This ensures we free up resources and don't trigger odd
  // bugs.
  void close() {
    _visibilityFilterController.close();
  }
}
