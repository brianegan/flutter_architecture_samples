import 'dart:async';

import 'package:blocs/blocs.dart';
import 'package:blocs/src/models/models.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';
import 'package:todos_repository/todos_repository.dart';

class MockReactiveTodosRepository extends Mock
    implements ReactiveTodosRepository {}

void main() {
  group('TodosBloc', () {
    test('should display all todos by default', () {
      final repository = new MockReactiveTodosRepository();
      final todos = [new TodoEntity("Hallo", "1", "Note", false)];
      final source = new BehaviorSubject<List<TodoEntity>>(seedValue: todos);

      when(repository.todos()).thenReturn(source.stream);

      final bloc = new TodosBloc(repository);

      expect(bloc.visibleTodos, emits(todos.map(Todo.fromEntity)));
    });

    test('should display completed todos', () {
      final repository = new MockReactiveTodosRepository();
      final todos = [
        new TodoEntity("Hallo", "1", "Note", false),
        new TodoEntity("Friend", "2", "Note", true),
      ];
      final source = new BehaviorSubject<List<TodoEntity>>(seedValue: todos);

      when(repository.todos()).thenReturn(source.stream);

      final bloc = new TodosBloc(repository);
      bloc.updateFilter.add(VisibilityFilter.completed);

      expect(bloc.visibleTodos, emits([Todo.fromEntity(todos.last)]));
    });

    test('should display active todos', () {
      final repository = new MockReactiveTodosRepository();
      final todos = [
        new TodoEntity("Hallo", "1", "Note", false),
        new TodoEntity("Friend", "2", "Note", true),
      ];
      final source = new BehaviorSubject<List<TodoEntity>>(seedValue: todos);

      when(repository.todos()).thenReturn(source.stream);

      final bloc = new TodosBloc(repository);
      bloc.updateFilter.add(VisibilityFilter.active);

      expect(bloc.visibleTodos, emits([Todo.fromEntity(todos.first)]));
    });

    test('should stream whether or not all todos are active', () {
      final repository = new MockReactiveTodosRepository();
      final todos = [
        new TodoEntity("Hallo", "1", "Note", false),
        new TodoEntity("Friend", "2", "Note", true),
      ];
      final source = new BehaviorSubject<List<TodoEntity>>(seedValue: todos);

      when(repository.todos()).thenReturn(source.stream);

      final bloc = new TodosBloc(repository);

      expect(bloc.allComplete, emits(false));
    });

    test('should stream whether or not all todos are active', () {
      final repository = new MockReactiveTodosRepository();
      final todos = [
        new TodoEntity("Hallo", "1", "Note", true),
        new TodoEntity("Friend", "2", "Note", true),
      ];
      final source = new BehaviorSubject<List<TodoEntity>>(seedValue: todos);

      when(repository.todos()).thenReturn(source.stream);

      final bloc = new TodosBloc(repository);

      expect(bloc.allComplete, emits(true));
    });

    test('should add todos to the repo', () async {
      final repository = new MockReactiveTodosRepository();
      final source = new BehaviorSubject<List<TodoEntity>>();
      final todo = new Todo("AddMe");

      when(repository.todos()).thenReturn(source.stream);
      when(repository.addNewTodo(todo.toEntity()))
          .thenReturn(new Future.value());

      final bloc = new TodosBloc(repository);
      bloc.addTodo.add(todo);

      verify(repository.addNewTodo(todo.toEntity()));
    });

    test('should send updates to the repo', () async {
      final repository = new MockReactiveTodosRepository();
      final update = new Todo('Waaaat');
      final source = new BehaviorSubject<List<TodoEntity>>();

      when(repository.todos()).thenReturn(source.stream);
      when(repository.updateTodo(update.toEntity()))
          .thenReturn(new Future.value());

      final bloc = new TodosBloc(repository);
      bloc.updateTodo.add(update);

      verify(repository.updateTodo(update.toEntity()));
    });

    test('should send deletions to the repo', () async {
      final repository = new MockReactiveTodosRepository();
      final source = new BehaviorSubject<List<TodoEntity>>();

      when(repository.todos()).thenReturn(source.stream);
      when(repository.deleteTodo(["1"])).thenReturn(new Future.value());

      final bloc = new TodosBloc(repository);
      bloc.deleteTodo.add("1");

      verify(repository.deleteTodo(["1"]));
    });

    test('should remove completed todos from the repo', () async {
      final repository = new MockReactiveTodosRepository();
      final todos = [
        new TodoEntity("Hallo", "1", "Note", false),
        new TodoEntity("Friend", "2", "Note", true),
      ];
      final source = new BehaviorSubject<List<TodoEntity>>(
        seedValue: todos,
        sync: true,
      );

      when(repository.todos()).thenReturn(source.stream);
      when(repository.deleteTodo(any)).thenReturn(new Future.value());

      final bloc = new TodosBloc(repository);
      bloc.clearCompleted.add(null);
      await new Future.delayed(new Duration(milliseconds: 100));

      verify(repository.deleteTodo(any));
    });
  });
}
