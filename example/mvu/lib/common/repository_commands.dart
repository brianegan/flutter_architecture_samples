import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:todos_repository/todos_repository.dart';

import 'package:todos_repository_flutter/todos_repository_flutter.dart';
import 'package:flutter_architecture_samples/uuid.dart';
import 'package:dartea/dartea.dart';

const _internalRepository = const TodosRepositoryFlutter(
  fileStorage: const FileStorage(
    "mvu_app",
    getApplicationDocumentsDirectory,
  ),
  webClient: const WebClient(),
);

final repoCmds = CmdRepository(_internalRepository);

abstract class RepositoryEvent {}

class OnTodoAdded implements RepositoryEvent {
  final TodoEntity entity;
  OnTodoAdded(this.entity);
}

class OnTodoRemoved implements RepositoryEvent {
  final TodoEntity entity;
  OnTodoRemoved(this.entity);
}

class OnTodoChanged implements RepositoryEvent {
  final TodoEntity entity;
  OnTodoChanged(this.entity);
}

class CmdRepository {
  final TodosRepository _repo;
  CmdRepository(this._repo);

  final StreamController<RepositoryEvent> _changesStreamController =
      new StreamController<RepositoryEvent>.broadcast();

  Cmd<TMsg> subscribe<TModel, TMsg>(TMsg mapMsg(RepositoryEvent m)) {
    Sub<TMsg> sub = (Dispatch<TMsg> dispatch) {
      _changesStreamController.stream.listen((m) {
        var mappedMsg = mapMsg(m);
        if (mappedMsg != null) {
          dispatch(mappedMsg);
        }
      });
    };
    return new Cmd.ofSub(sub);
  }

  Cmd<T> loadTodosCmd<T>(T onSuccess(List<TodoEntity> items),
          {T onError(Exception exc)}) =>
      Cmd.ofFutureFunc(_repo.loadTodos, onSuccess: onSuccess, onError: onError);

  Cmd<T> saveAllCmd<T>(List<TodoEntity> entities, {T onSuccess()}) => Cmd
      .ofFutureAction<T>(() => _repo.saveTodos(entities), onSuccess: onSuccess);

  Cmd<T> removeCmd<T>(TodoEntity todo, {T onSuccess()}) =>
      Cmd.ofFutureAction<T>(() async {
        var todos = await _repo.loadTodos();
        await _repo.saveTodos(todos.where((x) => x.id != todo.id).toList());
        _changesStreamController.add(OnTodoRemoved(todo));
      }, onSuccess: onSuccess);

  Cmd<T> saveCmd<T>(TodoEntity todo, {T onSuccess()}) =>
      Cmd.ofFutureAction<T>(() async {
        var todos = await _repo.loadTodos();
        await _repo
            .saveTodos(todos.map((x) => x.id == todo.id ? todo : x).toList());
        _changesStreamController.add(OnTodoChanged(todo));
      }, onSuccess: onSuccess);

  Cmd<T> createCmd<T>(T onSuccess(TodoEntity todo), String task, String note) =>
      Cmd.ofFutureFunc(() async {
        var todo = new TodoEntity(task, new Uuid().generateV4(), note, false);
        var todos = await _repo.loadTodos()
          ..add(todo);
        await _repo.saveTodos(todos);
        _changesStreamController.add(OnTodoAdded(todo));
        return todo;
      }, onSuccess: onSuccess);

  Cmd<T> updateDetailsCmd<T>(
          T onSuccess(TodoEntity todo), String id, String task, String note) =>
      Cmd.ofFutureFunc(() async {
        var todos = await _repo.loadTodos();
        var updated = todos
            .map((x) =>
                x.id == id ? new TodoEntity(task, id, note, x.complete) : x)
            .toList();
        await _repo.saveTodos(updated);
        var updatedTodo = updated.firstWhere((x) => x.id == id);
        _changesStreamController.add(OnTodoChanged(updatedTodo));
        return updatedTodo;
      }, onSuccess: onSuccess);
}
