// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:mvi_base/mvi_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';
import 'package:todos_repository/todos_repository.dart';

class MockReactiveTodosRepository extends Mock
    implements ReactiveTodosRepository {}

void main() {
  group('TodosListInteractor', () {
    test('should convert repo entities into Todos', () {
      final repository = new MockReactiveTodosRepository();
      final interactor = new TodosInteractor(repository);
      final todos = [new TodoEntity("Hallo", "1", "Note", false)];

      when(repository.todos())
          .thenAnswer((_) => new Stream.fromIterable([todos]));

      expect(interactor.todos, emits(todos.map(Todo.fromEntity)));
    });

    test('allComplete should stream false if some todos incomplete', () {
      final repository = new MockReactiveTodosRepository();
      final interactor = new TodosInteractor(repository);
      final todos = [
        new TodoEntity("Hallo", "1", "Note", false),
        new TodoEntity("Friend", "2", "Note", true),
      ];

      when(repository.todos())
          .thenAnswer((_) => new Stream.fromIterable([todos]));

      expect(interactor.allComplete, emits(false));
    });

    test('allComplete should stream true when all todos are complete', () {
      final repository = new MockReactiveTodosRepository();
      final interactor = new TodosInteractor(repository);
      final todos = [
        new TodoEntity("Hallo", "1", "Note", true),
        new TodoEntity("Friend", "2", "Note", true),
      ];
      when(repository.todos())
          .thenAnswer((_) => new Stream.fromIterable([todos]));

      expect(interactor.allComplete, emits(true));
    });

    test('hasCompletedTodos should be true when all todos are complete', () {
      final repository = new MockReactiveTodosRepository();
      final interactor = new TodosInteractor(repository);
      final todos = [
        new TodoEntity("Hallo", "1", "Note", true),
        new TodoEntity("Friend", "2", "Note", true),
      ];

      when(repository.todos())
          .thenAnswer((_) => new Stream.fromIterable([todos]));

      expect(interactor.hasCompletedTodos, emits(true));
    });

    test('hasCompletedTodos should be true when some todos are complete', () {
      final repository = new MockReactiveTodosRepository();
      final interactor = new TodosInteractor(repository);
      final todos = [
        new TodoEntity("Hallo", "1", "Note", false),
        new TodoEntity("Friend", "2", "Note", true),
      ];

      when(repository.todos())
          .thenAnswer((_) => new Stream.fromIterable([todos]));

      expect(interactor.hasCompletedTodos, emits(true));
    });

    test('hasCompletedTodos should be false when all todos are incomplete', () {
      final repository = new MockReactiveTodosRepository();
      final interactor = new TodosInteractor(repository);
      final todos = [
        new TodoEntity("Hallo", "1", "Note", false),
        new TodoEntity("Friend", "2", "Note", false),
      ];

      when(repository.todos())
          .thenAnswer((_) => new Stream.fromIterable([todos]));

      expect(interactor.hasCompletedTodos, emits(false));
    });

    test('should add todos to the repo', () async {
      final repository = new MockReactiveTodosRepository();
      final interactor = new TodosInteractor(repository);
      final todo = new Todo("AddMe");

      when(repository.todos()).thenAnswer((_) => new Stream.empty());
      when(repository.addNewTodo(todo.toEntity()))
          .thenReturn(new Future.value());

      interactor.addNewTodo(todo);

      verify(repository.addNewTodo(todo.toEntity()));
    });

    test('should send deletions to the repo', () async {
      final repository = new MockReactiveTodosRepository();
      final interactor = new TodosInteractor(repository);

      when(repository.todos()).thenAnswer((_) => new Stream.empty());
      when(repository.deleteTodo(["1"])).thenReturn(new Future.value());

      interactor.deleteTodo("1");

      verify(repository.deleteTodo(["1"]));
    });

    test('should remove completed todos from the repo', () async {
      final repository = new MockReactiveTodosRepository();
      final interactor = new TodosInteractor(repository);
      final todos = [
        new TodoEntity("Hallo", "1", "Note", false),
        new TodoEntity("Friend", "2", "Note", true),
      ];

      when(repository.todos())
          .thenAnswer((_) => new Stream.fromIterable([todos]));
      when(repository.deleteTodo(["2"])).thenReturn(new Future.sync(() {}));

      await interactor.clearCompleted();

      verify(repository.deleteTodo(["2"]));
    });

    test('if some todos incomplete, should toggle todos complete', () async {
      final repository = new MockReactiveTodosRepository();
      final interactor = new TodosInteractor(repository);
      final e1 = new TodoEntity("Hallo", "1", "Note", false);
      final e1Update = new TodoEntity("Hallo", "1", "Note", true);
      final e2 = new TodoEntity("Friend", "2", "Note", true);
      final todos = [e1, e2];
      final source = new BehaviorSubject<List<TodoEntity>>(
        seedValue: todos,
        sync: true,
      );

      when(repository.todos()).thenReturn(source.stream);
      when(repository.updateTodo(e1Update)).thenReturn(new Future.sync(() {}));

      await interactor.toggleAll(null);

      verify(repository.updateTodo(e1Update));
    });

    test('if all todos incomplete, should toggle all todos complete', () async {
      final repository = new MockReactiveTodosRepository();
      final interactor = new TodosInteractor(repository);
      final e1 = new TodoEntity("Hallo", "1", "Note", false);
      final e1Update = new TodoEntity("Hallo", "1", "Note", true);
      final e2 = new TodoEntity("Friend", "2", "Note", false);
      final e2Update = new TodoEntity("Friend", "2", "Note", true);
      final todos = [e1, e2];
      final source = new BehaviorSubject<List<TodoEntity>>(
        seedValue: todos,
        sync: true,
      );

      when(repository.todos()).thenReturn(source.stream);
      when(repository.updateTodo(e1Update)).thenReturn(new Future.sync(() {}));
      when(repository.updateTodo(e2Update)).thenReturn(new Future.sync(() {}));

      await interactor.toggleAll(null);

      verify(repository.updateTodo(e1Update));
      verify(repository.updateTodo(e2Update));
    });

    test('if all todos complete, should toggle todos incomplete', () async {
      final repository = new MockReactiveTodosRepository();
      final interactor = new TodosInteractor(repository);
      final e1 = new TodoEntity("Hallo", "1", "Note", true);
      final e1Update = new TodoEntity("Hallo", "1", "Note", false);
      final e2 = new TodoEntity("Friend", "2", "Note", true);
      final e2Update = new TodoEntity("Friend", "2", "Note", false);
      final todos = [e1, e2];
      final source = new BehaviorSubject<List<TodoEntity>>(
        seedValue: todos,
        sync: true,
      );

      when(repository.todos()).thenReturn(source.stream);
      when(repository.updateTodo(e1Update)).thenReturn(new Future.sync(() {}));
      when(repository.updateTodo(e2Update)).thenReturn(new Future.sync(() {}));

      await interactor.toggleAll(null);

      verify(repository.updateTodo(e1Update));
      verify(repository.updateTodo(e2Update));
    });
  });
}
