// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:listenable_collections/listenable_collections.dart';
import 'package:rvms_model_sample/display_todos/_manager/todo_manager_.dart';
import 'package:rvms_model_sample/display_todos/_model/todo.dart';
import 'package:rvms_model_sample/display_todos/_services/repository_service_.dart';

import '../../locator.dart';

class TodoManagerImplementation implements TodoManager {
  @override
  ValueListenable<List<Todo>> get allTodos => _todos;
  final _todos = ListNotifier<Todo>(data: []);

  @override
  ValueListenable<List<Todo>> get filteredTodos => _filteredTodos;
  ValueNotifier<List<Todo>> _filteredTodos;

  @override
  ValueListenable<String> get errors => _errors;
  ValueNotifier<String> _errors;

  @override
  VisibilityFilter get activeFilter => selectFilterCommand.value;

  @override
  Command<VisibilityFilter, VisibilityFilter> selectFilterCommand;
  @override
  Command<void, void> loadTodoCommand;
  @override
  Command<void, void> clearCompletedCommand;
  @override
  Command<String, String> upLoadCommand;

  TodoManagerImplementation({
    VisibilityFilter activeFilter,
  }) {
    loadTodoCommand = Command.createAsyncNoParamNoResult(loadTodos)
      ..thrownExceptions.listen((_, __) => _todos.clear());

    /// We wouldn't need to implement this as a command as we are not using any of the
    /// features that a command gives us.
    clearCompletedCommand = Command.createSyncNoParamNoResult(() {
      _todos.removeWhere((todo) => todo.complete);
    });

    /// if this app didn't have already a snackbar with undo function
    /// we could pass a changing text for  the snackbar that should
    /// be displayed when the command is finished
    ///
    /// I will add the needed code in the UI but comment it out
    upLoadCommand = Command.createAsync((snackBarText) async {
      await _uploadItems();
      return snackBarText;
    }, '');

    _errors = loadTodoCommand.thrownExceptions.mergeWith(
        [upLoadCommand.thrownExceptions]).map((error) => error.toString());

    selectFilterCommand = Command.createSync((filter) => filter, activeFilter);

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
  Future loadTodos() async {
    _todos.clear();
    return _todos.addAll(await locator<RepositoryService>().loadTodos());
  }

  @override
  void toggleAll() {
    var allComplete = _todos.every((todo) => todo.complete);
    _todos.startTransAction();
    for (var i = 0; i < _todos.length; i++) {
      _todos[i] = _todos[i].copy(complete: !allComplete);
    }
    _todos.endTransAction();
    upLoadCommand('Upload finished');
  }

  /// updates a [Todo] by replacing the item with the same id by the parameter [todo]
  @override
  void updateTodo(Todo todo) {
    assert(todo != null);
    assert(todo.id != null);
    var oldTodo = _todos.firstWhere((it) => it.id == todo.id);
    var replaceIndex = _todos.indexOf(oldTodo);
    _todos[replaceIndex] = todo;
    upLoadCommand('Update finished');
  }

  @override
  void removeTodo(Todo todo) {
    _todos.removeWhere((it) => it.id == todo.id);
    upLoadCommand('Todo deleted');
  }

  @override
  void addTodo(Todo todo) {
    _todos.add(todo);
    upLoadCommand('Todo added');
  }

  Future _uploadItems() async {
    /// to simulate a longer transaction to show that then a spinner
    /// is automatic displayed
    /// await Future.delayed(Duration(milliseconds: 2000));
    return await locator<RepositoryService>().saveTodos(_todos);
  }

  @override
  Todo todoById(String id) {
    return _todos.firstWhere((it) => it.id == id, orElse: () => null);
  }
}
