// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:mvi_base/mvi_base.dart';
import 'package:mvi_base/src/models/models.dart';
import 'package:test/test.dart';

class MockTodosListInteractor extends Mock implements TodosInteractor {}

class MockUserInteractor implements UserInteractor {
  @override
  Future<User> login() => Future.sync(() => User('Erica'));
}

void main() {
  group('MviTodosList', () {
    group('View', () {
      test('should clean up after itself', () {
        final view = TodosListView();

        view.tearDown();

        expect(view.addTodo.isClosed, isTrue);
        expect(view.updateTodo.isClosed, isTrue);
        expect(view.deleteTodo.isClosed, isTrue);
        expect(view.updateFilter.isClosed, isTrue);
        expect(view.clearCompleted.isClosed, isTrue);
        expect(view.toggleAll.isClosed, isTrue);
      });
    });

    group('Presenter', () {
      test('should have an initial state', () {
        final interactor = MockTodosListInteractor();
        final view = TodosListView();

        final presenter = TodosListPresenter(
          view: view,
          todosInteractor: interactor,
          userInteractor: MockUserInteractor(),
        );

        expect(presenter.latest, TodosListModel.initial());
      });

      test('should show all todos by default', () {
        final interactor = MockTodosListInteractor();
        final view = TodosListView();
        final todos = [Todo('Hi')];

        when(interactor.todos).thenAnswer((_) => Stream.fromIterable([todos]));
        when(interactor.allComplete)
            .thenAnswer((_) => Stream.fromIterable([false]));
        when(interactor.hasCompletedTodos)
            .thenAnswer((_) => Stream.fromIterable([false]));

        final presenter = TodosListPresenter(
          view: view,
          todosInteractor: interactor,
          userInteractor: MockUserInteractor(),
        );

        expect(
          presenter,
          emitsThrough(ModelWith(
            activeFilter: VisibilityFilter.all,
            visibleTodos: todos,
          )),
        );
      });

      test('should display completed todos', () {
        final interactor = MockTodosListInteractor();
        final view = TodosListView();
        final todos = [
          Todo('Hallo', complete: false),
          Todo('Friend', complete: true),
        ];

        when(interactor.todos).thenAnswer((_) => Stream.fromIterable([todos]));
        when(interactor.allComplete)
            .thenAnswer((_) => Stream.fromIterable([false]));
        when(interactor.hasCompletedTodos)
            .thenAnswer((_) => Stream.fromIterable([false]));

        final presenter = TodosListPresenter(
          view: view,
          todosInteractor: interactor,
          userInteractor: MockUserInteractor(),
        );
        view.updateFilter.add(VisibilityFilter.completed);

        expect(
          presenter,
          emitsThrough(ModelWith(visibleTodos: [todos.last])),
        );
      });

      test('should display active todos', () {
        final interactor = MockTodosListInteractor();
        final view = TodosListView();
        final todos = [
          Todo('Hallo', complete: false),
          Todo('Friend', complete: true),
        ];

        when(interactor.todos).thenAnswer((_) => Stream.fromIterable([todos]));
        when(interactor.allComplete)
            .thenAnswer((_) => Stream.fromIterable([false]));
        when(interactor.hasCompletedTodos)
            .thenAnswer((_) => Stream.fromIterable([false]));

        final presenter = TodosListPresenter(
          view: view,
          todosInteractor: interactor,
          userInteractor: MockUserInteractor(),
        );
        view.updateFilter.add(VisibilityFilter.active);

        expect(
          presenter,
          emitsThrough(ModelWith(visibleTodos: [todos.first])),
        );
      });

      test('allComplete should stream state of interactor', () {
        final interactor = MockTodosListInteractor();
        final view = TodosListView();
        final todos = [
          Todo('Hallo', complete: false),
          Todo('Friend', complete: true),
        ];

        when(interactor.todos).thenAnswer((_) => Stream.fromIterable([todos]));
        when(interactor.allComplete)
            .thenAnswer((_) => Stream.fromIterable([false]));
        when(interactor.hasCompletedTodos)
            .thenAnswer((_) => Stream.fromIterable([false]));

        final presenter = TodosListPresenter(
          view: view,
          todosInteractor: interactor,
          userInteractor: MockUserInteractor(),
        );

        expect(
          presenter,
          emitsThrough(ModelWith(allComplete: false)),
        );
      });

      test('hasCompletedTodos should reflect the interactor', () {
        final interactor = MockTodosListInteractor();
        final view = TodosListView();
        final todos = [
          Todo('Hallo', complete: false),
          Todo('Friend', complete: true),
        ];

        when(interactor.todos).thenAnswer((_) => Stream.fromIterable([todos]));
        when(interactor.allComplete)
            .thenAnswer((_) => Stream.fromIterable([false]));
        when(interactor.hasCompletedTodos)
            .thenAnswer((_) => Stream.fromIterable([true]));

        final presenter = TodosListPresenter(
          view: view,
          todosInteractor: interactor,
          userInteractor: MockUserInteractor(),
        );

        expect(
          presenter,
          emitsThrough(ModelWith(hasCompletedTodos: true)),
        );
      });

      test('should add todos to the interactor', () async {
        final interactor = MockTodosListInteractor();
        final view = TodosListView();
        final todos = [
          Todo('Hallo', complete: false),
          Todo('Friend', complete: true),
        ];

        when(interactor.todos).thenAnswer((_) => Stream.fromIterable([todos]));
        when(interactor.allComplete)
            .thenAnswer((_) => Stream.fromIterable([false]));
        when(interactor.hasCompletedTodos)
            .thenAnswer((_) => Stream.fromIterable([true]));

        final presenter = TodosListPresenter(
          view: view,
          todosInteractor: interactor,
          userInteractor: MockUserInteractor(),
        );
        presenter.setUp();
        view.addTodo.add(todos.first);

        verify(interactor.addNewTodo(todos.first));
      });

      test('should send deletions to the interactor', () async {
        final interactor = MockTodosListInteractor();
        final view = TodosListView();
        final todos = [
          Todo('Hallo', complete: false),
          Todo('Friend', complete: true),
        ];

        when(interactor.todos).thenAnswer((_) => Stream.fromIterable([todos]));
        when(interactor.allComplete)
            .thenAnswer((_) => Stream.fromIterable([false]));
        when(interactor.hasCompletedTodos)
            .thenAnswer((_) => Stream.fromIterable([true]));

        final presenter = TodosListPresenter(
          view: view,
          todosInteractor: interactor,
          userInteractor: MockUserInteractor(),
        );
        presenter.setUp();
        view.deleteTodo.add(todos.first.id);

        verify(interactor.deleteTodo(todos.first.id));
      });

      test('should remove completed todos from the interactor', () async {
        final interactor = MockTodosListInteractor();
        final view = TodosListView();
        final todos = [
          Todo('Hallo', complete: false),
          Todo('Friend', complete: true),
        ];

        when(interactor.todos).thenAnswer((_) => Stream.fromIterable([todos]));
        when(interactor.allComplete)
            .thenAnswer((_) => Stream.fromIterable([false]));
        when(interactor.hasCompletedTodos)
            .thenAnswer((_) => Stream.fromIterable([true]));

        final presenter = TodosListPresenter(
          view: view,
          todosInteractor: interactor,
          userInteractor: MockUserInteractor(),
        );
        presenter.setUp();
        view.clearCompleted.add(null);

        verify(interactor.clearCompleted(null));
      });

      test('should toggle complete', () async {
        final interactor = MockTodosListInteractor();
        final view = TodosListView();
        final todos = [
          Todo('Hallo', complete: false),
          Todo('Friend', complete: true),
        ];

        when(interactor.todos).thenAnswer((_) => Stream.fromIterable([todos]));
        when(interactor.allComplete)
            .thenAnswer((_) => Stream.fromIterable([false]));
        when(interactor.hasCompletedTodos)
            .thenAnswer((_) => Stream.fromIterable([true]));

        final presenter = TodosListPresenter(
          view: view,
          todosInteractor: interactor,
          userInteractor: MockUserInteractor(),
        );
        presenter.setUp();
        view.toggleAll.add(null);

        verify(interactor.toggleAll(null));
      });
    });
  });
}

class ModelWith extends Matcher {
  final VisibilityFilter activeFilter;
  final bool allComplete;
  final bool hasCompletedTodos;
  final List<Todo> visibleTodos;
  final bool loading;
  String errors = '';

  ModelWith({
    this.activeFilter,
    this.allComplete,
    this.hasCompletedTodos,
    this.visibleTodos,
    this.loading,
  });

  @override
  Description describe(Description description) {
    return description..add('Did not match fields: $errors');
  }

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is TodosListModel) {
      bool match = true;
      if (visibleTodos != null) {
        match = _listsEqual(visibleTodos, item.visibleTodos);
        errors += ' visibleTodos';
      }

      if (activeFilter != null) {
        match = activeFilter == item.activeFilter;
        errors += ' activeFilter';
      }

      if (allComplete != null) {
        match = allComplete == item.allComplete;
        errors += ' allComplete';
      }

      if (hasCompletedTodos != null) {
        match = hasCompletedTodos == item.hasCompletedTodos;
        errors += ' hasCompletedTodos';
      }

      if (loading != null) {
        match = loading == item.loading;
        errors += ' loading';
      }

      return match;
    }

    return false;
  }

  static bool _listsEqual(List<Todo> first, List<Todo> second) {
    if (first.length != second?.length) return false;

    for (int i = 0; i < first.length; i++) {
      if (first[i] != second[i]) {
        return false;
      }
    }
    return true;
  }
}
