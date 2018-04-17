// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mvi_base/src/models/models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todos_repository/todos_repository.dart';

typedef Model<ViewState, Intent> = Stream<ViewState> Function(Intent intent);
typedef View<ViewState, Intent> = Sink<Intent> Function(
    Model<ViewState, Intent>);

abstract class Disposable {
  Future dispose();
}

// A class that should contain a number of broadcast StreamControllers. These
// will glue the View to the Model and Drivers.
//
// The dispose method must be implemented and should `close` all
// StreamControllers
abstract class Intent implements Disposable {}

class Presenter<ViewState> implements Disposable {
  final BehaviorSubject<ViewState> _subject;
  final List<StreamSubscription<dynamic>> _effects;

  Presenter({
    @required Observable<ViewState> state,
    ViewState initialState,
    List<StreamSubscription<dynamic>> effects,
  })  : _effects = effects ?? [],
        _subject = _createSubject<ViewState>(state, initialState);

  // Get the current state. Useful for initial renders or re-renders when we
  // have already fetched the data
  ViewState get state => _subject.value;

  // A Stream
  Observable<ViewState> get stream => _subject.stream;

  @mustCallSuper
  Future dispose() =>
      Future.wait([_subject.close()]..addAll(_effects.map((s) => s.cancel())));

  static _createSubject<ViewState>(
    Stream<ViewState> state,
    ViewState initialState,
  ) {
    StreamSubscription<ViewState> subscription;
    BehaviorSubject<ViewState> _subject;

    _subject = new BehaviorSubject<ViewState>(
      seedValue: initialState,
      onListen: () {
        subscription = state.listen(
          _subject.add,
          onError: _subject.addError,
          onDone: _subject.close,
        );
      },
      onCancel: () => subscription.cancel(),
      sync: true,
    );

    return _subject;
  }
}

class TodosListIntent implements Intent {
  final addTodo = new StreamController<Todo>();
  final deleteTodo = new StreamController<String>();
  final updateFilter = new StreamController<VisibilityFilter>();
  final clearCompleted = new StreamController<void>();
  final toggleAll = new StreamController<void>();
  final updateTodo = new StreamController<Todo>();

  Future<List<dynamic>> dispose() {
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

class TodoListState {
  final VisibilityFilter activeFilter;
  final bool allComplete;
  final bool hasCompletedTodos;
  final List<Todo> visibleTodos;
  final bool loading;

  TodoListState({
    this.activeFilter,
    this.allComplete,
    this.hasCompletedTodos,
    this.visibleTodos,
    this.loading,
  });

  factory TodoListState.initial() => new TodoListState(loading: true);
}

class TodoListModel extends MviModelOld<TodoListState> {
  TodoListModel(TodosListIntent intent, TodosListInteractor driver)
      : super(
          initialState: new TodoListState.initial(),
          state: Observable.combineLatest4(
            intent.updateFilter.stream,
            driver.allComplete,
            driver.hasCompletedTodos,
            Observable.combineLatest2<List<Todo>, VisibilityFilter, List<Todo>>(
              driver.todos,
              intent.updateFilter.stream,
              _filterTodos,
            ),
            (activeFilter, allComplete, hasCompletedTodos, visibleTodos) =>
                new TodoListState(
                  activeFilter: activeFilter,
                  allComplete: allComplete,
                  hasCompletedTodos: hasCompletedTodos,
                  visibleTodos: visibleTodos,
                  loading: false,
                ),
          ),
        );

  static List<Todo> _filterTodos(List<Todo> todos, VisibilityFilter filter) {
    return todos.where((todo) {
      switch (filter) {
        case VisibilityFilter.all:
          return true;
        case VisibilityFilter.active:
          return !todo.complete;
        case VisibilityFilter.completed:
          return todo.complete;
      }
    }).toList();
  }
}

class TodoListPresenter extends Presenter<TodoListState> {
  final ReactiveTodosRepository repository;

  TodoListPresenter(TodosListIntent intent, TodosListInteractor interactor)
      : super(
          effects: [
            intent.updateTodo.stream
                .listen((todo) => repository.updateTodo(todo.toEntity())),
            intent.addTodo.stream
                .listen((todo) => repository.addNewTodo(todo.toEntity())),
            intent.deleteTodo.stream
                .listen((id) => repository.deleteTodo([id])),
            new Observable(intent.clearCompleted.stream)
                .concatMap<List<String>>(
                    (_) => _todos(repository).map(_completedTodoIds).take(1))
                .listen((ids) => repository.deleteTodo(ids)),
            new Observable(intent.toggleAll.stream)
                .switchMap<List<Todo>>(
                    (_) => _todos(repository).map(_todosToUpdate).take(1))
                .listen((updates) => updates.forEach(
                    (update) => repository.updateTodo(update.toEntity())))
          ],
          initialState: new TodoListState.initial(),
          state: Observable.combineLatest4(
            intent.updateFilter.stream,
            driver.allComplete,
            driver.hasCompletedTodos,
            Observable.combineLatest2<List<Todo>, VisibilityFilter, List<Todo>>(
              driver.todos,
              intent.updateFilter.stream,
              _filterTodos,
            ),
            (activeFilter, allComplete, hasCompletedTodos, visibleTodos) =>
                new TodoListState(
                  activeFilter: activeFilter,
                  allComplete: allComplete,
                  hasCompletedTodos: hasCompletedTodos,
                  visibleTodos: visibleTodos,
                  loading: false,
                ),
          ),
        );

  static List<Todo> _filterTodos(List<Todo> todos, VisibilityFilter filter) {
    return todos.where((todo) {
      switch (filter) {
        case VisibilityFilter.all:
          return true;
        case VisibilityFilter.active:
          return !todo.complete;
        case VisibilityFilter.completed:
          return todo.complete;
      }
    }).toList();
  }
}

class TodosListInteractor {
  final ReactiveTodosRepository repository;

  TodosListInteractor(this.repository);

  Stream<List<Todo>> get todos => _todos(repository);

  Stream<bool> get allComplete => todos.map(_allComplete);

  Stream<bool> get hasCompletedTodos => todos.map(_hasCompletedTodos);

  static Stream<List<Todo>> _todos(ReactiveTodosRepository repository) {
    return repository
        .todos()
        .map((entities) => entities.map(Todo.fromEntity).toList());
  }

  static bool _hasCompletedTodos(List<Todo> todos) {
    return todos.any((todo) => todo.complete);
  }

  static List<String> _completedTodoIds(List<Todo> todos) {
    return todos.fold<List<String>>([], (prev, todo) {
      if (todo.complete) {
        return prev..add(todo.id);
      } else {
        return prev;
      }
    });
  }

  static List<Todo> _todosToUpdate(List<Todo> todos) {
    final allComplete = _allComplete(todos);

    return todos.fold<List<Todo>>([], (prev, todo) {
      if (allComplete) {
        return prev..add(todo.copyWith(complete: false));
      } else if (!allComplete && !todo.complete) {
        return prev..add(todo.copyWith(complete: true));
      } else {
        return prev;
      }
    });
  }

  static bool _allComplete(List<Todo> todos) =>
      todos.every((todo) => todo.complete);
}
