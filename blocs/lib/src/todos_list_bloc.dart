// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:blocs/src/models/models.dart';
import 'package:blocs/src/todos_interactor.dart';
import 'package:rxdart/rxdart.dart';

class TodosListBloc {
  // Inputs
  final Sink<Todo> addTodo;
  final Sink<String> deleteTodo;
  final Sink<VisibilityFilter> updateFilter;
  final Sink<void> clearCompleted;
  final Sink<void> toggleAll;
  final Sink<Todo> updateTodo;

  // Outputs
  final Stream<VisibilityFilter> activeFilter;
  final Stream<bool> allComplete;
  final Stream<bool> hasCompletedTodos;
  final Stream<List<Todo>> visibleTodos;

  // Cleanup
  final List<StreamSubscription<dynamic>> _subscriptions;

  factory TodosListBloc(TodosInteractor interactor) {
    // We'll use a series of StreamControllers to glue together our inputs and
    // outputs.
    //
    // StreamControllers have both a Sink and a Stream. We'll expose the Sinks
    // publicly so users can send information to the Bloc. We'll use the Streams
    // internally to react to that user input.
    final addTodoController = StreamController<Todo>(sync: true);
    final clearCompletedController = PublishSubject<void>(sync: true);
    final deleteTodoController = StreamController<String>(sync: true);
    final toggleAllController = PublishSubject<void>(sync: true);
    final updateTodoController = StreamController<Todo>(sync: true);
    final updateFilterController = BehaviorSubject<VisibilityFilter>.seeded(
      VisibilityFilter.all,
      sync: true,
    );

    // In some cases, we need to simply route user interactions to our data
    // layer. In this case, we'll listen to the streams. In order to clean
    // these subscriptions up, we'll pop them in a list and ensure we cancel
    // all of them in the `close` method when they are no longer needed.
    final subscriptions = <StreamSubscription<dynamic>>[
      // When a user updates an item, update the repository
      updateTodoController.stream.listen(interactor.updateTodo),
      // When a user adds an item, add it to the repository
      addTodoController.stream.listen(interactor.addNewTodo),
      // When a user removes an item, remove it from the repository
      deleteTodoController.stream.listen(interactor.deleteTodo),
      // When a user clears the completed items, convert the current list of
      // todos into a list of ids, then send that to the repository
      clearCompletedController.stream.listen(interactor.clearCompleted),
      // When a user toggles all todos, calculate whether all todos should be
      // marked complete or incomplete and push the change to the repository
      toggleAllController.stream.listen(interactor.toggleAll),
    ];

    // To calculate the visible todos, we combine the todos with the current
    // visibility filter and return the filtered todos.
    //
    // Every time the todos or the filter changes the visible items will emit
    // once again. We also convert the normal Stream into a BehaviorSubject
    // so the Stream can be listened to multiple times
    final visibleTodosController = BehaviorSubject<List<Todo>>();

    Rx.combineLatest2<List<Todo>, VisibilityFilter, List<Todo>>(
      interactor.todos,
      updateFilterController.stream,
      _filterTodos,
    ).pipe(visibleTodosController);

    return TodosListBloc._(
      addTodoController,
      deleteTodoController,
      updateFilterController,
      clearCompletedController,
      toggleAllController,
      updateTodoController,
      visibleTodosController.stream,
      interactor.allComplete,
      interactor.hasCompletedTodos,
      updateFilterController.stream,
      subscriptions,
    );
  }

  TodosListBloc._(
    this.addTodo,
    this.deleteTodo,
    this.updateFilter,
    this.clearCompleted,
    this.toggleAll,
    this.updateTodo,
    this.visibleTodos,
    this.allComplete,
    this.hasCompletedTodos,
    this.activeFilter,
    this._subscriptions,
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
    addTodo.close();
    deleteTodo.close();
    updateFilter.close();
    clearCompleted.close();
    toggleAll.close();
    updateTodo.close();
    _subscriptions.forEach((subscription) => subscription.cancel());
  }
}
