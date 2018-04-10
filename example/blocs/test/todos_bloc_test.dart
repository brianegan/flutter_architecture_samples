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
  group('TodosListBloc', () {
    test('should display all todos by default', () {
      final repository = new MockReactiveTodosRepository();
      final todos = [new TodoEntity("Hallo", "1", "Note", false)];
      final source = new BehaviorSubject<List<TodoEntity>>(seedValue: todos);

      when(repository.todos()).thenReturn(source.stream);

      final bloc = new TodosListBloc(repository);

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

      final bloc = new TodosListBloc(repository);
      bloc.updateFilter.add(VisibilityFilter.completed);

      expect(
        bloc.visibleTodos,
        emitsThrough([Todo.fromEntity(todos.last)]),
      );
    });

    test('should display active todos', () {
      final repository = new MockReactiveTodosRepository();
      final todos = [
        new TodoEntity("Hallo", "1", "Note", false),
        new TodoEntity("Friend", "2", "Note", true),
      ];
      final source = new BehaviorSubject<List<TodoEntity>>(seedValue: todos);

      when(repository.todos()).thenReturn(source.stream);

      final bloc = new TodosListBloc(repository);
      bloc.updateFilter.add(VisibilityFilter.active);

      expect(
        bloc.visibleTodos,
        emitsThrough([Todo.fromEntity(todos.first)]),
      );
    });

    test('allComplete should stream false if some todos incomplete', () {
      final repository = new MockReactiveTodosRepository();
      final todos = [
        new TodoEntity("Hallo", "1", "Note", false),
        new TodoEntity("Friend", "2", "Note", true),
      ];
      final source = new BehaviorSubject<List<TodoEntity>>(seedValue: todos);

      when(repository.todos()).thenReturn(source.stream);

      final bloc = new TodosListBloc(repository);

      expect(bloc.allComplete, emits(false));
    });

    test('allComplete should stream true when all todos are complete', () {
      final repository = new MockReactiveTodosRepository();
      final todos = [
        new TodoEntity("Hallo", "1", "Note", true),
        new TodoEntity("Friend", "2", "Note", true),
      ];
      final source = new BehaviorSubject<List<TodoEntity>>(seedValue: todos);

      when(repository.todos()).thenReturn(source.stream);

      final bloc = new TodosListBloc(repository);

      expect(bloc.allComplete, emits(true));
    });

    test('hasCompletedTodos should be true when all todos are complete', () {
      final repository = new MockReactiveTodosRepository();
      final todos = [
        new TodoEntity("Hallo", "1", "Note", true),
        new TodoEntity("Friend", "2", "Note", true),
      ];
      final source = new BehaviorSubject<List<TodoEntity>>(seedValue: todos);

      when(repository.todos()).thenReturn(source.stream);

      final bloc = new TodosListBloc(repository);

      expect(bloc.hasCompletedTodos, emits(true));
    });

    test('hasCompletedTodos should be true when some todos are complete', () {
      final repository = new MockReactiveTodosRepository();
      final todos = [
        new TodoEntity("Hallo", "1", "Note", false),
        new TodoEntity("Friend", "2", "Note", true),
      ];
      final source = new BehaviorSubject<List<TodoEntity>>(seedValue: todos);

      when(repository.todos()).thenReturn(source.stream);

      final bloc = new TodosListBloc(repository);

      expect(bloc.hasCompletedTodos, emits(true));
    });

    test('hasCompletedTodos should be false when all todos are incomplete', () {
      final repository = new MockReactiveTodosRepository();
      final todos = [
        new TodoEntity("Hallo", "1", "Note", false),
        new TodoEntity("Friend", "2", "Note", false),
      ];
      final source = new BehaviorSubject<List<TodoEntity>>(seedValue: todos);

      when(repository.todos()).thenReturn(source.stream);

      final bloc = new TodosListBloc(repository);

      expect(bloc.hasCompletedTodos, emits(false));
    });

    test('should add todos to the repo', () async {
      final repository = new MockReactiveTodosRepository();
      final source = new BehaviorSubject<List<TodoEntity>>();
      final todo = new Todo("AddMe");

      when(repository.todos()).thenReturn(source.stream);
      when(repository.addNewTodo(todo.toEntity()))
          .thenReturn(new Future.value());

      final bloc = new TodosListBloc(repository);
      bloc.addTodo.add(todo);

      verify(repository.addNewTodo(todo.toEntity()));
    });

    test('should send deletions to the repo', () async {
      final repository = new MockReactiveTodosRepository();
      final source = new BehaviorSubject<List<TodoEntity>>();

      when(repository.todos()).thenReturn(source.stream);
      when(repository.deleteTodo(["1"])).thenReturn(new Future.value());

      final bloc = new TodosListBloc(repository);
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
      when(repository.deleteTodo(["2"])).thenReturn(new Future.sync(() {}));

      final bloc = new TodosListBloc(repository);
      bloc.clearCompleted.add(null);

      await source.stream.first;
      verify(repository.deleteTodo(["2"]));
    });

    test('if some todos incomplete, should toggle todos complete', () async {
      final repository = new MockReactiveTodosRepository();
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

      final bloc = new TodosListBloc(repository);
      bloc.toggleAll.add(null);

      await source.stream.first;
      verify(repository.updateTodo(e1Update));
    });

    test('if all todos incomplete, should toggle all todos complete', () async {
      final repository = new MockReactiveTodosRepository();
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

      final bloc = new TodosListBloc(repository);
      bloc.toggleAll.add(null);

      await source.stream.first;
      verify(repository.updateTodo(e1Update));
      verify(repository.updateTodo(e2Update));
    });

    test('if all todos complete, should toggle todos incomplete', () async {
      final repository = new MockReactiveTodosRepository();
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

      final bloc = new TodosListBloc(repository);
      bloc.toggleAll.add(null);

      await source.stream.first;
      verify(repository.updateTodo(e1Update));
      verify(repository.updateTodo(e2Update));
    });
  });
}
