// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mvi_base/src/models/models.dart';
import 'package:mvi_base/src/models/user.dart';
import 'package:mvi_base/src/mvi_core.dart';
import 'package:mvi_base/src/todos_interactor.dart';
import 'package:mvi_base/src/user_interactor.dart';
import 'package:rxdart/rxdart.dart';

class TodosListModel {
  final VisibilityFilter activeFilter;
  final bool allComplete;
  final bool hasCompletedTodos;
  final List<Todo> visibleTodos;
  final bool loading;
  final User user;

  TodosListModel({
    this.activeFilter,
    this.allComplete,
    this.hasCompletedTodos,
    this.visibleTodos,
    this.loading,
    this.user,
  });

  factory TodosListModel.initial() => TodosListModel(loading: true);

  @override
  String toString() {
    return 'TodosListModel{activeFilter: $activeFilter, allComplete: $allComplete, hasCompletedTodos: $hasCompletedTodos, visibleTodos: $visibleTodos, loading: $loading, user: $user}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodosListModel &&
          runtimeType == other.runtimeType &&
          activeFilter == other.activeFilter &&
          allComplete == other.allComplete &&
          hasCompletedTodos == other.hasCompletedTodos &&
          visibleTodos == other.visibleTodos &&
          loading == other.loading &&
          user == other.user;

  @override
  int get hashCode =>
      activeFilter.hashCode ^
      allComplete.hashCode ^
      hasCompletedTodos.hashCode ^
      visibleTodos.hashCode ^
      loading.hashCode ^
      user.hashCode;
}

class TodosListView implements MviView {
  final addTodo = StreamController<Todo>.broadcast(sync: true);

  final deleteTodo = StreamController<String>.broadcast(sync: true);

  final clearCompleted = StreamController<void>.broadcast(sync: true);

  final toggleAll = StreamController<void>.broadcast(sync: true);

  final updateTodo = StreamController<Todo>.broadcast(sync: true);

  final updateFilter = BehaviorSubject<VisibilityFilter>.seeded(
    VisibilityFilter.all,
  );

  Future<List<dynamic>> tearDown() {
    return Future.wait([
      addTodo.close(),
      deleteTodo.close(),
      updateFilter.close(),
      clearCompleted.close(),
      toggleAll.close(),
      updateTodo.close(),
    ]);
  }
}

class TodosListPresenter extends MviPresenter<TodosListModel> {
  final TodosListView _view;
  final TodosInteractor _interactor;

  TodosListPresenter({
    @required TodosListView view,
    @required TodosInteractor todosInteractor,
    @required UserInteractor userInteractor,
  })  : _view = view,
        _interactor = todosInteractor,
        super(
          initialModel: TodosListModel.initial(),
          stream: _buildStream(view, todosInteractor, userInteractor),
        );

  @override
  void setUp() {
    subscriptions.addAll([
      _view.updateTodo.stream.listen(_interactor.updateTodo),
      _view.addTodo.stream.listen(_interactor.addNewTodo),
      _view.deleteTodo.stream.listen(_interactor.deleteTodo),
      _view.clearCompleted.stream.listen(_interactor.clearCompleted),
      _view.toggleAll.stream.listen(_interactor.toggleAll),
    ]);
  }

  static Stream<TodosListModel> _buildStream(
    TodosListView view,
    TodosInteractor interactor,
    UserInteractor repository,
  ) {
    return Rx.defer(() async* {
      yield await repository.login();
    }).flatMap((user) {
      return Rx.combineLatest4(
        view.updateFilter.stream,
        interactor.allComplete,
        interactor.hasCompletedTodos,
        Rx.combineLatest2<List<Todo>, VisibilityFilter, List<Todo>>(
          interactor.todos,
          view.updateFilter.stream,
          _filterTodos,
        ),
        (activeFilter, allComplete, hasCompletedTodos, visibleTodos) {
          return TodosListModel(
            user: user,
            activeFilter: activeFilter,
            allComplete: allComplete,
            hasCompletedTodos: hasCompletedTodos,
            visibleTodos: visibleTodos,
            loading: false,
          );
        },
      );
    });
  }

  static List<Todo> _filterTodos(List<Todo> todos, VisibilityFilter filter) {
    switch (filter) {
      case VisibilityFilter.active:
        return todos.where((todo) => !todo.complete).toList();
      case VisibilityFilter.completed:
        return todos.where((todo) => todo.complete).toList();
      case VisibilityFilter.all:
      default:
        return todos;
    }
  }
}
