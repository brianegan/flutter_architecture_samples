import 'dart:async';

import 'package:test/test.dart';

import 'package:todos_repository_core/todos_repository_core.dart';

import 'package:frideos_library/blocs/todos_bloc.dart';
import 'package:frideos_library/blocs/stats_bloc.dart';
import 'package:frideos_library/models/models.dart';

class MockRepository extends TodosRepository {
  List<TodoEntity> entities;

  MockRepository(List<Todo> todos)
      : entities = todos.map((it) => it.toEntity()).toList();

  @override
  Future<List<TodoEntity>> loadTodos() {
    return Future.value(entities);
  }

  @override
  Future saveTodos(List<TodoEntity> todos) {
    return Future.sync(() => entities = todos);
  }
}

void main() {
  group('StatsBloc', () {
    test('should stream the number of active todos', () async {
      final statsBloc = StatsBloc();

      var todos = [
        Todo('a'),
        Todo('b'),
        Todo('c', complete: true),
      ];

      final todosBloc = TodosBloc(repository: MockRepository(todos));

      todosBloc.todosSender.setReceiver(statsBloc.todosItems);

      await todosBloc.loadTodos();

      await expectLater(statsBloc.numActive.outStream, emits(2));
    });

    test('should stream the number of completed todos', () async {
      final statsBloc = StatsBloc();

      final todos = [
        Todo('a'),
        Todo('b'),
        Todo('Hallo', complete: true),
        Todo('Friend', complete: true),
        Todo('Flutter', complete: true),
      ];

      final todosBloc = TodosBloc(repository: MockRepository(todos));

      todosBloc.todosSender.setReceiver(statsBloc.todosItems);

      await todosBloc.loadTodos();

      await expectLater(statsBloc.numComplete.outStream, emits(3));
    });
  });
}
