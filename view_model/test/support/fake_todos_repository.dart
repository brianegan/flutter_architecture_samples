import 'dart:async';

import 'package:todos_repository_core/todos_repository_core.dart';

class FakeTodosRepository implements TodosRepository {
  FakeTodosRepository({List<TodoEntity> todos = const [], this.loadCompleter})
    : _todos = List.of(todos);

  final Completer<List<TodoEntity>>? loadCompleter;
  final List<List<TodoEntity>> savedTodos = [];
  List<TodoEntity> _todos;
  int loadCount = 0;

  @override
  Future<List<TodoEntity>> loadTodos() async {
    loadCount++;
    if (loadCompleter case final completer?) {
      return completer.future;
    }
    return List.of(_todos);
  }

  @override
  Future<void> saveTodos(List<TodoEntity> todos) async {
    _todos = List.of(todos);
    savedTodos.add(List.of(todos));
  }
}
