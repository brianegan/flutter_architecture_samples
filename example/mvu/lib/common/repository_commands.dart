import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:todos_repository/todos_repository.dart';

import 'package:todos_repository_flutter/todos_repository_flutter.dart';
import 'package:flutter_architecture_samples/uuid.dart';
import 'package:dartea/dartea.dart';

const _repository = const TodosRepositoryFlutter(
  fileStorage: const FileStorage(
    "mvu_app",
    getApplicationDocumentsDirectory,
  ),
  webClient: const WebClient(),
);

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

Cmd<T> createLoadCommand<T>(
        T onSuccess(List<TodoEntity> items), T onError(Exception exc)) =>
    Cmd.ofFutureFunc(_repository.loadTodos,
        onSuccess: onSuccess, onError: onError);

Cmd<T> createPositiveLoadCommand<T>(T onSuccess(List<TodoEntity> items)) =>
    Cmd.ofFutureFunc(_repository.loadTodos, onSuccess: onSuccess);

Cmd<T> createSaveCommand<T>(List<TodoEntity> entities) =>
    Cmd.ofFutureAction<T>(() => _repository.saveTodos(entities));

Cmd<T> removeTodo<T>(TodoEntity todo) => Cmd.ofFutureAction<T>(() async {
      var todos = await _repository.loadTodos();
      await _repository.saveTodos(todos.where((x) => x.id != todo.id).toList());
      _changesStreamController.add(OnTodoRemoved(todo));
    });

Cmd<T> saveTodo<T>(TodoEntity todo) => Cmd.ofFutureAction<T>(() async {
      var todos = await _repository.loadTodos();
      await _repository
          .saveTodos(todos.map((x) => x.id == todo.id ? todo : x).toList());
      _changesStreamController.add(OnTodoChanged(todo));
    });

Cmd<T> createTodo<T>(T onSuccess(TodoEntity todo), String task, String note) =>
    Cmd.ofFutureFunc(() async {
      var todo = new TodoEntity(task, new Uuid().generateV4(), note, false);
      var todos = await _repository.loadTodos()
        ..add(todo);
      await _repository.saveTodos(todos);
      _changesStreamController.add(OnTodoAdded(todo));
      return todo;
    }, onSuccess: onSuccess);

Cmd<T> updateTodo<T>(
        T onSuccess(TodoEntity todo), String id, String task, String note) =>
    Cmd.ofFutureFunc(() async {
      var todos = await _repository.loadTodos();
      var updated = todos
          .map((x) =>
              x.id == id ? new TodoEntity(task, id, note, x.complete) : x)
          .toList();
      await _repository.saveTodos(updated);
      var updatedTodo = updated.firstWhere((x) => x.id == id);
      _changesStreamController.add(OnTodoChanged(updatedTodo));
      return updatedTodo;
    }, onSuccess: onSuccess);
