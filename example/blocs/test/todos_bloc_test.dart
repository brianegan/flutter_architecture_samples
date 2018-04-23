import 'dart:async';

import 'package:blocs/blocs.dart';
import 'package:blocs/src/models/models.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:todos_repository/todos_repository.dart';

class MockReactiveTodosRepository extends Mock
    implements ReactiveTodosRepository {}

class MockTodosListInteractor extends Mock implements TodosInteractor {}

void main() {
  group('TodosListBloc', () {
    test('should display all todos by default', () {
      final interactor = new MockTodosListInteractor();
      final todos = [new Todo('Hallo')];

      when(interactor.todos)
          .thenAnswer((_) => new Stream.fromIterable([todos]));

      final bloc = new TodosListBloc(interactor);

      expect(bloc.visibleTodos, emits(todos));
    });

    test('should display completed todos', () {
      final interactor = new MockTodosListInteractor();
      final todos = [
        new Todo('Hallo'),
        new Todo('Friend', complete: true),
      ];

      when(interactor.todos)
          .thenAnswer((_) => new Stream.fromIterable([todos]));

      final bloc = new TodosListBloc(interactor);
      bloc.updateFilter.add(VisibilityFilter.completed);

      expect(
        bloc.visibleTodos,
        emitsThrough([todos.last]),
      );
    });

    test('should display active todos', () {
      final interactor = new MockTodosListInteractor();
      final todos = [
        new Todo('Hallo'),
        new Todo('Friend', complete: true),
      ];

      when(interactor.todos)
          .thenAnswer((_) => new Stream.fromIterable([todos]));

      final bloc = new TodosListBloc(interactor);
      bloc.updateFilter.add(VisibilityFilter.active);

      expect(
        bloc.visibleTodos,
        emitsThrough([todos.first]),
      );
    });

    test('should stream the current visibility filter', () {
      final interactor = new MockTodosListInteractor();
      final todos = [
        new Todo('Hallo'),
        new Todo('Friend', complete: true),
      ];

      when(interactor.todos)
          .thenAnswer((_) => new Stream.fromIterable([todos]));

      final bloc = new TodosListBloc(interactor);

      bloc.updateFilter.add(VisibilityFilter.completed);

      expect(
        bloc.activeFilter,
        emits(VisibilityFilter.completed),
      );
    });

    test('allComplete should stream from the interactor', () {
      final interactor = new MockTodosListInteractor();

      when(interactor.todos)
          .thenAnswer((_) => new Stream<List<Todo>>.fromIterable([[]]));
      when(interactor.allComplete)
          .thenAnswer((_) => new Stream.fromIterable([false]));

      final bloc = new TodosListBloc(interactor);

      expect(bloc.allComplete, emits(false));
    });

    test('hasCompletedTodos should stream from the interactor', () {
      final interactor = new MockTodosListInteractor();

      when(interactor.todos)
          .thenAnswer((_) => new Stream<List<Todo>>.fromIterable([[]]));
      when(interactor.hasCompletedTodos)
          .thenAnswer((_) => new Stream.fromIterable([true]));

      final bloc = new TodosListBloc(interactor);

      expect(bloc.hasCompletedTodos, emits(true));
    });

    test('should add todos to the interactor', () async {
      final interactor = new MockTodosListInteractor();
      final todo = new Todo('AddMe');

      when(interactor.todos).thenAnswer((_) => new Stream.fromIterable([
            [todo]
          ]));
      when(interactor.addNewTodo(todo)).thenReturn(new Future.value());

      final bloc = new TodosListBloc(interactor);
      bloc.addTodo.add(todo);

      verify(interactor.addNewTodo(todo));
    });

    test('should send deletions to the interactor', () async {
      final interactor = new MockTodosListInteractor();

      when(interactor.todos)
          .thenAnswer((_) => new Stream<List<Todo>>.fromIterable([[]]));
      when(interactor.deleteTodo('1')).thenReturn(new Future.value());

      final bloc = new TodosListBloc(interactor);
      bloc.deleteTodo.add('1');

      verify(interactor.deleteTodo('1'));
    });

    test('should remove completed todos from the interactor', () async {
      final interactor = new MockTodosListInteractor();

      when(interactor.todos)
          .thenAnswer((_) => new Stream<List<Todo>>.fromIterable([[]]));
      when(interactor.clearCompleted(null))
          .thenAnswer((_) => new Future.value());

      final bloc = new TodosListBloc(interactor);
      bloc.clearCompleted.add(null);

      verify(interactor.clearCompleted(null));
    });

    test('should toggle all with the interactor', () async {
      final interactor = new MockTodosListInteractor();

      when(interactor.todos)
          .thenAnswer((_) => new Stream<List<Todo>>.fromIterable([[]]));
      when(interactor.toggleAll(null))
          .thenAnswer((_) => new Future<List<dynamic>>.value());

      final bloc = new TodosListBloc(interactor);
      bloc.toggleAll.add(null);

      verify(interactor.toggleAll(null));
    });
  });
}
