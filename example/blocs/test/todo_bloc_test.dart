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
  group('TodoBloc', () {
    test('should load a todo from the Repo', () {
      final repository = new MockReactiveTodosRepository();
      final bloc = new TodoBloc(repository);
      final entity = new TodoEntity("Hallo", "1", "Note", false);
      final todos = [entity];
      final source = new BehaviorSubject<List<TodoEntity>>(seedValue: todos);

      when(repository.todos()).thenReturn(source.stream);

      expect(bloc.todo("1"), emits(Todo.fromEntity(entity)));
    });

    test('emits null if the todo is not present', () {
      final repository = new MockReactiveTodosRepository();
      final bloc = new TodoBloc(repository);
      final entity = new TodoEntity("Hallo", "1", "Note", false);
      final todos = [entity];
      final source = new BehaviorSubject<List<TodoEntity>>(seedValue: todos);

      when(repository.todos()).thenReturn(source.stream);

      expect(bloc.todo("2"), emits(null));
    });



    test('should send deletions to the repo', () async {
      final repository = new MockReactiveTodosRepository();
      final source = new BehaviorSubject<List<TodoEntity>>();

      when(repository.todos()).thenReturn(source.stream);
      when(repository.deleteTodo(["1"])).thenReturn(new Future.value());

      final bloc = new TodoBloc(repository);
      bloc.deleteTodo.add("1");

      verify(repository.deleteTodo(["1"]));
    });

    test('should send updates to the repo', () async {
      final repository = new MockReactiveTodosRepository();
      final update = new Todo('Waaaat');
      final source = new BehaviorSubject<List<TodoEntity>>();

      when(repository.todos()).thenReturn(source.stream);
      when(repository.updateTodo(update.toEntity()))
          .thenReturn(new Future.value());

      final bloc = new TodoBloc(repository);
      bloc.updateTodo.add(update);

      verify(repository.updateTodo(update.toEntity()));
    });
  });
}
