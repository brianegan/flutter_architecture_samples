import 'dart:async';

import 'package:dartea/dartea.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:todos_repository_core/todos_repository_core.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

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
  Cmd<T> loadTodosCmd<T>(T Function(List<TodoEntity> items) onSuccess,
      {T Function(Exception exc) onError});

  Cmd<T> saveAllCmd<T>(List<TodoEntity> entities, {T Function() onSuccess});

  Cmd<T> removeCmd<T>(TodoEntity todo, {T Function() onSuccess});

  Cmd<T> saveCmd<T>(TodoEntity todo, {T Function() onSuccess});

  Cmd<T> createCmd<T>(
      T Function(TodoEntity todo) onSuccess, String task, String note);

  Cmd<T> updateDetailsCmd<T>(T Function(TodoEntity todo) onSuccess, String id,
      String task, String note);

  Stream<RepositoryEvent> get events;
}

class TodosCmdRepository implements CmdRepository {
  final TodosRepository _repo;

  TodosCmdRepository(this._repo);

  final StreamController<RepositoryEvent> _changesStreamController =
      StreamController<RepositoryEvent>.broadcast();

  @override
  Stream<RepositoryEvent> get events => _changesStreamController.stream;

  @override
  Cmd<T> loadTodosCmd<T>(T Function(List<TodoEntity> items) onSuccess,
          {T Function(Exception exc) onError}) =>
      Cmd.ofAsyncFunc(_repo.loadTodos, onSuccess: onSuccess, onError: onError);

  @override
  Cmd<T> saveAllCmd<T>(List<TodoEntity> entities, {T Function() onSuccess}) =>
      Cmd.ofAsyncAction<T>(() => _repo.saveTodos(entities),
          onSuccess: onSuccess);

  @override
  Cmd<T> removeCmd<T>(TodoEntity todo, {T Function() onSuccess}) =>
      Cmd.ofAsyncAction<T>(() async {
        var todos = await _repo.loadTodos();
        await _repo.saveTodos(todos.where((x) => x.id != todo.id).toList());
        _changesStreamController.add(RepoOnTodoRemoved(todo));
      }, onSuccess: onSuccess);

  @override
  Cmd<T> saveCmd<T>(TodoEntity todo, {T Function() onSuccess}) =>
      Cmd.ofAsyncAction<T>(() async {
        var todos = await _repo.loadTodos();
        await _repo
            .saveTodos(todos.map((x) => x.id == todo.id ? todo : x).toList());
        _changesStreamController.add(RepoOnTodoChanged(todo));
      }, onSuccess: onSuccess);

  @override
  Cmd<T> createCmd<T>(
          T Function(TodoEntity todo) onSuccess, String task, String note) =>
      Cmd.ofAsyncFunc(() async {
        var todo = TodoEntity(task, Uuid().generateV4(), note, false);
        var todos = await _repo.loadTodos()
          ..add(todo);
        await _repo.saveTodos(todos);
        _changesStreamController.add(RepoOnTodoAdded(todo));
        return todo;
      }, onSuccess: onSuccess);

  @override
  Cmd<T> updateDetailsCmd<T>(T Function(TodoEntity todo) onSuccess, String id,
          String task, String note) =>
      Cmd.ofAsyncFunc(() async {
        var todos = await _repo.loadTodos();
        var updated = todos
            .map((x) => x.id == id ? TodoEntity(task, id, note, x.complete) : x)
            .toList();
        await _repo.saveTodos(updated);
        var updatedTodo = updated.firstWhere((x) => x.id == id);
        _changesStreamController.add(RepoOnTodoChanged(updatedTodo));
        return updatedTodo;
      }, onSuccess: onSuccess);
}

const _internalRepository = LocalStorageRepository(
  localStorage: FileStorage(
    'mvu_app',
    getApplicationDocumentsDirectory,
  ),
  webClient: WebClient(),
);

final CmdRepository repoCmds = TodosCmdRepository(_internalRepository);
