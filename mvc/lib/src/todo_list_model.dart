// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:todos_repository_core/todos_repository_core.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';
import 'package:mvc/src/models.dart';

class TodoListModel {
  TodoListModel({TodosRepository repo, VisibilityFilter activeFilter})
      : _activeFilter = activeFilter ?? VisibilityFilter.all {
    /// The rest of the app need not know of its existence.
    repository = repo ??
        LocalStorageRepository(
          localStorage: const FileStorage(
            'mvc_app',
            getApplicationDocumentsDirectory,
          ),
        );
  }
  TodosRepository repository;

  VisibilityFilter get activeFilter => _activeFilter;
  set activeFilter(VisibilityFilter filter) => _activeFilter = filter;
  VisibilityFilter _activeFilter;

  List<Todo> get todos => _todos.toList();
  List<Todo> _todos = [];

  bool get isLoading => _isLoading;
  bool _isLoading = false;

  /// Loads remote data
  Future loadTodos() {
    _isLoading = true;
    return repository.loadTodos().then((loadedTodos) {
      _todos = loadedTodos.map(Todo.fromEntity).toList();
      _isLoading = false;
    }).catchError((err) {
      _isLoading = false;
      _todos = [];
    });
  }

  List<Todo> get filteredTodos => _todos.where((todo) {
        switch (activeFilter) {
          case VisibilityFilter.active:
            return !todo.complete;
          case VisibilityFilter.completed:
            return todo.complete;
          case VisibilityFilter.all:
          default:
            return true;
        }
      }).toList();

  void clearCompleted() {
    _todos.removeWhere((todo) => todo.complete);
    _uploadItems();
  }

  void toggleAll() {
    var allComplete = todos.every((todo) => todo.complete);
    _todos = _todos.map((todo) => todo.copy(complete: !allComplete)).toList();
    _uploadItems();
  }

  /// updates by replacing the item with the same id by the parameter
  void updateTodo(Todo todo) {
    assert(todo != null);
    assert(todo.id != null);
    var oldTodo = _todos.firstWhere((it) => it.id == todo.id);
    var replaceIndex = _todos.indexOf(oldTodo);
    _todos.replaceRange(replaceIndex, replaceIndex + 1, [todo]);
    _uploadItems();
  }

  void removeTodo(Todo todo) {
    _todos.removeWhere((it) => it.id == todo.id);
    _uploadItems();
  }

  void addTodo(Todo todo) {
    _todos.add(todo);
    _uploadItems();
  }

  void _uploadItems() {
    repository.saveTodos(_todos.map((it) => it.toEntity()).toList());
  }

  Todo todoById(String id) {
    return _todos.firstWhere((it) => it.id == id, orElse: () => null);
  }
}

enum VisibilityFilter { all, active, completed }

class To {
  /// Convert from a Map object
  static Todo todo(Map data) {
    return Todo(data['task'],
        complete: data['complete'], note: data['note'], id: data['id']);
  }

  /// Used to 'interface' with the View in the MVC design pattern.
  static Map map(Todo obj) => {
        'task': obj == null ? '' : obj.task,
        'note': obj == null ? '' : obj.note,
        'complete': obj == null ? false : obj.complete,
        'id': obj == null ? null : obj.id,
      };
}
