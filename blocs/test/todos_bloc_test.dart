import 'dart:async';

import 'package:blocs/blocs.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

import 'todos_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ReactiveTodosRepository>(),
  MockSpec<TodosInteractor>(),
])
void main() {
  group('TodosListBloc', () {
    test('should display all todos by default', () {
      final interactor = MockTodosInteractor();
      final todos = [Todo('Hallo')];

      when(interactor.todos).thenAnswer((_) => Stream.fromIterable([todos]));

      final bloc = TodosListBloc(interactor);

      expect(bloc.visibleTodos, emits(todos));
    });

    test('should display completed todos', () {
      final interactor = MockTodosInteractor();
      final todos = [Todo('Hallo'), Todo('Friend', complete: true)];

      when(interactor.todos).thenAnswer((_) => Stream.fromIterable([todos]));

      final bloc = TodosListBloc(interactor);
      bloc.updateFilter.add(VisibilityFilter.completed);

      expect(bloc.visibleTodos, emitsThrough([todos.last]));
    });

    test('should display active todos', () {
      final interactor = MockTodosInteractor();
      final todos = [Todo('Hallo'), Todo('Friend', complete: true)];

      when(interactor.todos).thenAnswer((_) => Stream.fromIterable([todos]));

      final bloc = TodosListBloc(interactor);
      bloc.updateFilter.add(VisibilityFilter.active);

      expect(bloc.visibleTodos, emitsThrough([todos.first]));
    });

    test('should stream the current visibility filter', () {
      final interactor = MockTodosInteractor();
      final todos = [Todo('Hallo'), Todo('Friend', complete: true)];

      when(interactor.todos).thenAnswer((_) => Stream.fromIterable([todos]));

      final bloc = TodosListBloc(interactor);

      bloc.updateFilter.add(VisibilityFilter.completed);

      expect(bloc.activeFilter, emits(VisibilityFilter.completed));
    });

    test('allComplete should stream from the interactor', () {
      final interactor = MockTodosInteractor();

      when(
        interactor.todos,
      ).thenAnswer((_) => Stream<List<Todo>>.fromIterable([[]]));
      when(
        interactor.allComplete,
      ).thenAnswer((_) => Stream.fromIterable([false]));

      final bloc = TodosListBloc(interactor);

      expect(bloc.allComplete, emits(false));
    });

    test('hasCompletedTodos should stream from the interactor', () {
      final interactor = MockTodosInteractor();

      when(
        interactor.todos,
      ).thenAnswer((_) => Stream<List<Todo>>.fromIterable([[]]));
      when(
        interactor.hasCompletedTodos,
      ).thenAnswer((_) => Stream.fromIterable([true]));

      final bloc = TodosListBloc(interactor);

      expect(bloc.hasCompletedTodos, emits(true));
    });

    test('should add todos to the interactor', () async {
      final interactor = MockTodosInteractor();
      final todo = Todo('AddMe');

      when(interactor.todos).thenAnswer(
        (_) => Stream.fromIterable([
          [todo],
        ]),
      );
      when(interactor.addNewTodo(todo)).thenAnswer((_) => Future.value());

      final bloc = TodosListBloc(interactor);
      bloc.addTodo.add(todo);

      verify(interactor.addNewTodo(todo));
    });

    test('should send deletions to the interactor', () async {
      final interactor = MockTodosInteractor();

      when(
        interactor.todos,
      ).thenAnswer((_) => Stream<List<Todo>>.fromIterable([[]]));
      when(interactor.deleteTodo('1')).thenAnswer((_) => Future.value());

      final bloc = TodosListBloc(interactor);
      bloc.deleteTodo.add('1');

      verify(interactor.deleteTodo('1'));
    });

    test('should remove completed todos from the interactor', () async {
      final interactor = MockTodosInteractor();

      when(
        interactor.todos,
      ).thenAnswer((_) => Stream<List<Todo>>.fromIterable([[]]));
      when(interactor.clearCompleted(null)).thenAnswer((_) => Future.value());

      final bloc = TodosListBloc(interactor);
      bloc.clearCompleted.add(null);

      verify(interactor.clearCompleted(null));
    });

    test('should toggle all with the interactor', () async {
      final interactor = MockTodosInteractor();

      when(
        interactor.todos,
      ).thenAnswer((_) => Stream<List<Todo>>.fromIterable([[]]));
      when(interactor.toggleAll(null)).thenAnswer((_) async => []);

      final bloc = TodosListBloc(interactor);
      bloc.toggleAll.add(null);

      verify(interactor.toggleAll(null));
    });
  });
}
