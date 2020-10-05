// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rvms_model_sample/display_todos/_manager/todo_manager_.dart';
import 'package:rvms_model_sample/display_todos/_model/todo.dart';
import 'package:todos_repository_core/todos_repository_core.dart';
import 'package:todos_repository_simple/todos_repository_simple.dart';

class TodoManagerImplementation implements TodoManager {
  TodosRepository repository;

  ValueListenable<List<Todo>> get allTodos => _todos;
  ValueNotifier<List<Todo>> _todos = ValueNotifier<List<Todo>>([]);

  ValueListenable<List<Todo>> get filteredTodos => _filteredTodos;
  ValueNotifier<List<Todo>> _filteredTodos;

  ValueListenable<String> get errors => _errors;
  ValueNotifier<String> _errors;

  @override
  VisibilityFilter get activeFilter => selectFilterCommand.value;

  Command<VisibilityFilter, VisibilityFilter> selectFilterCommand;
  Command<void, void> loadTodoCommand;
  Command<void, void> clearCompletedCommand;
  Command<String, String> upLoadCommand;

  // ValueListenable errors = upLoadCommand.thrownExceptions.combineLatest(loadTodoCommand.thrownExceptions,)

  TodoManagerImplementation({VisibilityFilter activeFilter}) {
    repository = const TodosRepositoryFlutter(
      fileStorage: const FileStorage(
        'rvms_todos',
        getApplicationDocumentsDirectory,
      ),
    );

    loadTodoCommand = Command.createAsyncNoParamNoResult(loadTodos)
      ..thrownExceptions.listen((_, __) => _todos.value = []);

    selectFilterCommand =
        Command.createSync((filter) => filter, VisibilityFilter.all);

    clearCompletedCommand = Command.createSyncNoParamNoResult(() {
      _todos.value = _todos.value..removeWhere((todo) => todo.complete);
    });

    upLoadCommand = Command.createAsync((snackBarText) async {
      await _uploadItems();
      return snackBarText;
    }, '');

    /// the combineLatest ensures that [todos] get's updated whenever [_todos]
    /// changes or when [selectFilterCommand is called]
    _filteredTodos = selectFilterCommand
        .combineLatest<List<Todo>, List<Todo>>(_todos, (filter, todos) {
      return todos.where((todo) {
        switch (filter) {
          case VisibilityFilter.active:
            return !todo.complete;
          case VisibilityFilter.completed:
            return todo.complete;
          case VisibilityFilter.all:
          default:
            return true;
        }
      }).toList();
    });
  }

  /// Loads remote data
  ///
  /// Call this initially and when the user manually refreshes
  Future loadTodos() {
    return repository.loadTodos().then((loadedTodos) {
      _todos.value = loadedTodos.map(Todo.fromEntity).toList();
    });
  }

  void toggleAll() {
    var allComplete = _filteredTodos.value.every((todo) => todo.complete);
    _todos.value =
        _todos.value.map((todo) => todo.copy(complete: !allComplete)).toList();
    upLoadCommand('Upload finished');
  }

  /// updates a [Todo] by replacing the item with the same id by the parameter [todo]
  void updateTodo(Todo todo) {
    assert(todo != null);
    assert(todo.id != null);
    var oldTodo = _todos.value.firstWhere((it) => it.id == todo.id);
    var replaceIndex = _todos.value.indexOf(oldTodo);
    _todos.value = _todos.value
      ..replaceRange(replaceIndex, replaceIndex + 1, [todo]);
    upLoadCommand('Update finished');
  }

  void removeTodo(Todo todo) {
    _todos.value = _todos.value..removeWhere((it) => it.id == todo.id);
    upLoadCommand('Todo deleted');
  }

  void addTodo(Todo todo) {
    _todos.value = _todos.value..add(todo);
    upLoadCommand('Todo added');
  }

  Future _uploadItems() {
    return repository
        .saveTodos(_todos.value.map((it) => it.toEntity()).toList());
  }

  Todo todoById(String id) {
    return _todos.value.firstWhere((it) => it.id == id, orElse: () => null);
  }
}
