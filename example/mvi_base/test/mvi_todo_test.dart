// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:mvi_base/mvi_base.dart';
import 'package:mvi_base/src/models/models.dart';
import 'package:test/test.dart';

class MockTodosInteractor extends Mock implements TodosInteractor {}

void main() {
  group('MviTodo', () {
    group('Presenter', () {
      test('should load a todo', () {
        final interactor = MockTodosInteractor();
        final todo = Todo("Hallo");

        when(interactor.todo(todo.id)).thenReturn(Stream.fromIterable([todo]));

        final presenter = DetailPresenter(
          id: todo.id,
          view: DetailView(),
          interactor: interactor,
        );

        expect(presenter, emits(todo));
      });

      test('should send deletions to the interactor', () async {
        final interactor = MockTodosInteractor();
        final todo = Todo("Hallo");
        final view = DetailView();

        when(interactor.todo(todo.id)).thenReturn(Stream.fromIterable([todo]));

        final presenter = DetailPresenter(
          id: todo.id,
          view: view,
          interactor: interactor,
        );
        presenter.setUp();
        view.deleteTodo.add(todo.id);

        verify(interactor.deleteTodo(todo.id));
      });

      test('should send updates to the interactor', () async {
        final interactor = MockTodosInteractor();
        final todo = Todo("Hallo");
        final view = DetailView();

        when(interactor.todo(todo.id)).thenReturn(Stream.fromIterable([todo]));

        final presenter = DetailPresenter(
          id: todo.id,
          view: view,
          interactor: interactor,
        );
        presenter.setUp();
        view.updateTodo.add(todo);

        verify(interactor.updateTodo(todo));
      });
    });

    group('View', () {
      test('should clean up after itself', () async {
        final view = DetailView();

        view.tearDown();

        expect(view.deleteTodo.isClosed, isTrue);
        expect(view.updateTodo.isClosed, isTrue);
      });
    });
  });
}
