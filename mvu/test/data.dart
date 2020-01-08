import 'dart:async';

import 'package:mvu/common/repository_commands.dart';
import 'package:dartea/dartea.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

List<TodoEntity> createTodos({bool complete}) => [
      TodoEntity('Buy milk', '1', 'soy', complete ?? false),
      TodoEntity('Buy bread', '2', 'italian one', complete ?? true),
      TodoEntity('Buy meat', '3', 'or chicken', complete ?? false),
      TodoEntity('Buy water', '4', 'carbonated and still', complete ?? true),
      TodoEntity('Read book', '5', 'interesting one', complete ?? false),
      TodoEntity('Watch football', '6', '', complete ?? true),
      TodoEntity('Sleep', '7', 'well', complete ?? false),
    ];

List<TodoEntity> createTodosForStats(int activeCount, int completedCount) {
  final result = <TodoEntity>[];
  for (var i = 0; i < activeCount; i++) {
    var todo = TodoEntity('todo $i', '$i', 'note for todo #$i', false);
    result.add(todo);
  }
  var totalLength = result.length + completedCount;
  for (var i = result.length; i < totalLength; i++) {
    var todo = TodoEntity('todo $i', '$i', 'note for todo #$i', true);
    result.add(todo);
  }
  return result;
}

class InMemoryTodosRepository implements TodosRepository {
  final items = <TodoEntity>[];
  final bool isBrokern;
  InMemoryTodosRepository(
      {Iterable<TodoEntity> initialItems, this.isBrokern = false}) {
    if (initialItems != null) {
      items.addAll(initialItems);
    }
  }
  @override
  Future<List<TodoEntity>> loadTodos() {
    if (isBrokern) {
      throw Exception('repo is broken');
    }
    return Future.value(items.toList());
  }

  @override
  Future saveTodos(List<TodoEntity> todos) => Future.sync(() {
        items.clear();
        items.addAll(todos);
      });
}

class TestTodosCmdRepository implements CmdRepository {
  final createdEffects = <RepoEffect>[];

  @override
  Cmd<T> createCmd<T>(
      T Function(TodoEntity todo) onSuccess, String task, String note) {
    final entity = TodoEntity(task, 'new_id', note, false);
    createdEffects.add(CreateTodoEffect(task, note));
    return Cmd.ofFunc(() => entity, onSuccess: onSuccess);
  }

  @override
  Cmd<T> loadTodosCmd<T>(T Function(List<TodoEntity> items) onSuccess,
      {T Function(Exception exc) onError}) {
    final todos = createTodos();
    createdEffects.add(LoadTodosEffect());
    return Cmd.ofFunc(() => todos, onSuccess: onSuccess);
  }

  @override
  Cmd<T> removeCmd<T>(TodoEntity todo, {T Function() onSuccess}) {
    createdEffects.add(RemoveTodoEffect(todo));
    return Cmd.ofAction(() {}, onSuccess: onSuccess);
  }

  @override
  Cmd<T> saveAllCmd<T>(List<TodoEntity> entities, {T Function() onSuccess}) {
    createdEffects.add(SaveAllTodosEffect(entities));
    return Cmd.ofAction(() {}, onSuccess: onSuccess);
  }

  @override
  Cmd<T> saveCmd<T>(TodoEntity todo, {T Function() onSuccess}) {
    createdEffects.add(SaveTodoEffect(todo));
    return Cmd.ofAction(() {}, onSuccess: onSuccess);
  }

  @override
  Cmd<T> updateDetailsCmd<T>(T Function(TodoEntity todo) onSuccess, String id,
      String task, String note) {
    createdEffects.add(UpdateDetailsEffect(id, task, note));
    final updatedTodo = TodoEntity(task, id, note, false);
    return Cmd.ofFunc(() => updatedTodo, onSuccess: onSuccess);
  }

  void invalidate() => createdEffects.clear();

  @override
  Stream<RepositoryEvent> get events => events.asBroadcastStream();
}

abstract class RepoEffect {}

class LoadTodosEffect implements RepoEffect {}

class CreateTodoEffect implements RepoEffect {
  final String task;
  final String note;
  CreateTodoEffect(this.task, this.note);
}

class RemoveTodoEffect implements RepoEffect {
  final TodoEntity entity;
  RemoveTodoEffect(this.entity);
}

class SaveAllTodosEffect implements RepoEffect {
  final List<TodoEntity> entities;
  SaveAllTodosEffect(this.entities);
}

class SaveTodoEffect implements RepoEffect {
  final TodoEntity entity;
  SaveTodoEffect(this.entity);
}

class UpdateDetailsEffect implements RepoEffect {
  final String id;
  final String task;
  final String note;
  UpdateDetailsEffect(this.id, this.task, this.note);
}
