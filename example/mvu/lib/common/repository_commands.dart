import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:todos_repository/todos_repository.dart';

import 'package:todos_repository_flutter/todos_repository_flutter.dart';
import 'package:flutter_architecture_samples/uuid.dart';
import 'package:dartea/dartea.dart';

abstract class RepositoryEvent {}

class RepoOnTodoAdded implements RepositoryEvent {
  final TodoEntity entity;
  RepoOnTodoAdded(this.entity);
}

class RepoOnTodoRemoved implements RepositoryEvent {
  final TodoEntity entity;
  RepoOnTodoRemoved(this.entity);
}

class RepoOnTodoChanged implements RepositoryEvent {
  final TodoEntity entity;
  RepoOnTodoChanged(this.entity);
}

abstract class CmdRepository {
  Cmd<T> loadTodosCmd<T>(T onSuccess(List<TodoEntity> items),
      {T onError(Exception exc)});
  Cmd<T> saveAllCmd<T>(List<TodoEntity> entities, {T onSuccess()});
  Cmd<T> removeCmd<T>(TodoEntity todo, {T onSuccess()});
  Cmd<T> saveCmd<T>(TodoEntity todo, {T onSuccess()});
  Cmd<T> createCmd<T>(T onSuccess(TodoEntity todo), String task, String note);
  Cmd<T> updateDetailsCmd<T>(
      T onSuccess(TodoEntity todo), String id, String task, String note);
  Stream<RepositoryEvent> get events;
}

class TodosCmdRepository implements CmdRepository {
  final TodosRepository _repo;
  TodosCmdRepository(this._repo);

  final StreamController<RepositoryEvent> _changesStreamController =
      new StreamController<RepositoryEvent>.broadcast();

  Stream<RepositoryEvent> get events => _changesStreamController.stream;

  Cmd<T> loadTodosCmd<T>(T onSuccess(List<TodoEntity> items),
          {T onError(Exception exc)}) =>
      Cmd.ofAsyncFunc(_repo.loadTodos, onSuccess: onSuccess, onError: onError);

  Cmd<T> saveAllCmd<T>(List<TodoEntity> entities, {T onSuccess()}) => Cmd
      .ofAsyncAction<T>(() => _repo.saveTodos(entities), onSuccess: onSuccess);

  Cmd<T> removeCmd<T>(TodoEntity todo, {T onSuccess()}) =>
      Cmd.ofAsyncAction<T>(() async {
        var todos = await _repo.loadTodos();
        await _repo.saveTodos(todos.where((x) => x.id != todo.id).toList());
        _changesStreamController.add(RepoOnTodoRemoved(todo));
      }, onSuccess: onSuccess);

  Cmd<T> saveCmd<T>(TodoEntity todo, {T onSuccess()}) =>
      Cmd.ofAsyncAction<T>(() async {
        var todos = await _repo.loadTodos();
        await _repo
            .saveTodos(todos.map((x) => x.id == todo.id ? todo : x).toList());
        _changesStreamController.add(RepoOnTodoChanged(todo));
      }, onSuccess: onSuccess);

  Cmd<T> createCmd<T>(T onSuccess(TodoEntity todo), String task, String note) =>
      Cmd.ofAsyncFunc(() async {
        var todo = new TodoEntity(task, new Uuid().generateV4(), note, false);
        var todos = await _repo.loadTodos()
          ..add(todo);
        await _repo.saveTodos(todos);
        _changesStreamController.add(RepoOnTodoAdded(todo));
        return todo;
      }, onSuccess: onSuccess);

  Cmd<T> updateDetailsCmd<T>(
          T onSuccess(TodoEntity todo), String id, String task, String note) =>
      Cmd.ofAsyncFunc(() async {
        var todos = await _repo.loadTodos();
        var updated = todos
            .map((x) =>
                x.id == id ? new TodoEntity(task, id, note, x.complete) : x)
            .toList();
        await _repo.saveTodos(updated);
        var updatedTodo = updated.firstWhere((x) => x.id == id);
        _changesStreamController.add(RepoOnTodoChanged(updatedTodo));
        return updatedTodo;
      }, onSuccess: onSuccess);
}

const _internalRepository = const TodosRepositoryFlutter(
  fileStorage: const FileStorage(
    "mvu_app",
    getApplicationDocumentsDirectory,
  ),
  webClient: const WebClient(),
);

final CmdRepository repoCmds = TodosCmdRepository(_internalRepository);
