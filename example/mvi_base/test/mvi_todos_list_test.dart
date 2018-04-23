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
  Future<User> login() => new Future.sync(() => new User('Erica'));
}

void main() {
  group('MviTodosList', () {
    group('View', () {
      test('should clean up after itself', () {
        final view = new TodosListView();

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
        final interactor = new MockTodosListInteractor();
        final view = new TodosListView();

        final presenter = new TodosListPresenter(
          view: view,
          todosInteractor: interactor,
          userInteractor: new MockUserInteractor(),
        );

        expect(presenter.latest, new TodosListModel.initial());
      });

      test('should show all todos by default', () {
        final interactor = new MockTodosListInteractor();
        final view = new TodosListView();
        final todos = [new Todo('Hi')];

        when(interactor.todos).thenReturn(new Stream.fromIterable([todos]));
        when(interactor.allComplete)
            .thenReturn(new Stream.fromIterable([false]));
        when(interactor.hasCompletedTodos)
            .thenReturn(new Stream.fromIterable([false]));

        final presenter = new TodosListPresenter(
          view: view,
          todosInteractor: interactor,
          userInteractor: new MockUserInteractor(),
        );

        expect(
          presenter,
          emitsThrough(new ModelWith(
            activeFilter: VisibilityFilter.all,
            visibleTodos: todos,
          )),
        );
      });

      test('should display completed todos', () {
        final interactor = new MockTodosListInteractor();
        final view = new TodosListView();
        final todos = [
          new Todo("Hallo", complete: false),
          new Todo("Friend", complete: true),
        ];

        when(interactor.todos).thenReturn(new Stream.fromIterable([todos]));
        when(interactor.allComplete)
            .thenReturn(new Stream.fromIterable([false]));
        when(interactor.hasCompletedTodos)
            .thenReturn(new Stream.fromIterable([false]));

        final presenter = new TodosListPresenter(
          view: view,
          todosInteractor: interactor,
          userInteractor: new MockUserInteractor(),
        );
        view.updateFilter.add(VisibilityFilter.completed);

        expect(
          presenter,
          emitsThrough(new ModelWith(visibleTodos: [todos.last])),
        );
      });

      test('should display active todos', () {
        final interactor = new MockTodosListInteractor();
        final view = new TodosListView();
        final todos = [
          new Todo("Hallo", complete: false),
          new Todo("Friend", complete: true),
        ];

        when(interactor.todos).thenReturn(new Stream.fromIterable([todos]));
        when(interactor.allComplete)
            .thenReturn(new Stream.fromIterable([false]));
        when(interactor.hasCompletedTodos)
            .thenReturn(new Stream.fromIterable([false]));

        final presenter = new TodosListPresenter(
          view: view,
          todosInteractor: interactor,
          userInteractor: new MockUserInteractor(),
        );
        view.updateFilter.add(VisibilityFilter.active);

        expect(
          presenter,
          emitsThrough(new ModelWith(visibleTodos: [todos.first])),
        );
      });

      test('allComplete should stream state of interactor', () {
        final interactor = new MockTodosListInteractor();
        final view = new TodosListView();
        final todos = [
          new Todo("Hallo", complete: false),
          new Todo("Friend", complete: true),
        ];

        when(interactor.todos).thenReturn(new Stream.fromIterable([todos]));
        when(interactor.allComplete)
            .thenReturn(new Stream.fromIterable([false]));
        when(interactor.hasCompletedTodos)
            .thenReturn(new Stream.fromIterable([false]));

        final presenter = new TodosListPresenter(
          view: view,
          todosInteractor: interactor,
          userInteractor: new MockUserInteractor(),
        );

        expect(
          presenter,
          emitsThrough(new ModelWith(allComplete: false)),
        );
      });

      test('hasCompletedTodos should reflect the interactor', () {
        final interactor = new MockTodosListInteractor();
        final view = new TodosListView();
        final todos = [
          new Todo("Hallo", complete: false),
          new Todo("Friend", complete: true),
        ];

        when(interactor.todos).thenReturn(new Stream.fromIterable([todos]));
        when(interactor.allComplete)
            .thenReturn(new Stream.fromIterable([false]));
        when(interactor.hasCompletedTodos)
            .thenReturn(new Stream.fromIterable([true]));

        final presenter = new TodosListPresenter(
          view: view,
          todosInteractor: interactor,
          userInteractor: new MockUserInteractor(),
        );

        expect(
          presenter,
          emitsThrough(new ModelWith(hasCompletedTodos: true)),
        );
      });

      test('should add todos to the interactor', () async {
        final interactor = new MockTodosListInteractor();
        final view = new TodosListView();
        final todos = [
          new Todo("Hallo", complete: false),
          new Todo("Friend", complete: true),
        ];

        when(interactor.todos).thenReturn(new Stream.fromIterable([todos]));
        when(interactor.allComplete)
            .thenReturn(new Stream.fromIterable([false]));
        when(interactor.hasCompletedTodos)
            .thenReturn(new Stream.fromIterable([true]));

        final presenter = new TodosListPresenter(
          view: view,
          todosInteractor: interactor,
          userInteractor: new MockUserInteractor(),
        );
        presenter.setUp();
        view.addTodo.add(todos.first);

        verify(interactor.addNewTodo(todos.first));
      });

      test('should send deletions to the interactor', () async {
        final interactor = new MockTodosListInteractor();
        final view = new TodosListView();
        final todos = [
          new Todo("Hallo", complete: false),
          new Todo("Friend", complete: true),
        ];

        when(interactor.todos).thenReturn(new Stream.fromIterable([todos]));
        when(interactor.allComplete)
            .thenReturn(new Stream.fromIterable([false]));
        when(interactor.hasCompletedTodos)
            .thenReturn(new Stream.fromIterable([true]));

        final presenter = new TodosListPresenter(
          view: view,
          todosInteractor: interactor,
          userInteractor: new MockUserInteractor(),
        );
        presenter.setUp();
        view.deleteTodo.add(todos.first.id);

        verify(interactor.deleteTodo(todos.first.id));
      });

      test('should remove completed todos from the interactor', () async {
        final interactor = new MockTodosListInteractor();
        final view = new TodosListView();
        final todos = [
          new Todo("Hallo", complete: false),
          new Todo("Friend", complete: true),
        ];

        when(interactor.todos).thenReturn(new Stream.fromIterable([todos]));
        when(interactor.allComplete)
            .thenReturn(new Stream.fromIterable([false]));
        when(interactor.hasCompletedTodos)
            .thenReturn(new Stream.fromIterable([true]));

        final presenter = new TodosListPresenter(
          view: view,
          todosInteractor: interactor,
          userInteractor: new MockUserInteractor(),
        );
        presenter.setUp();
        view.clearCompleted.add(null);

        verify(interactor.clearCompleted(null));
      });

      test('should toggle complete', () async {
        final interactor = new MockTodosListInteractor();
        final view = new TodosListView();
        final todos = [
          new Todo("Hallo", complete: false),
          new Todo("Friend", complete: true),
        ];

        when(interactor.todos).thenReturn(new Stream.fromIterable([todos]));
        when(interactor.allComplete)
            .thenReturn(new Stream.fromIterable([false]));
        when(interactor.hasCompletedTodos)
            .thenReturn(new Stream.fromIterable([true]));

        final presenter = new TodosListPresenter(
          view: view,
          todosInteractor: interactor,
          userInteractor: new MockUserInteractor(),
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
