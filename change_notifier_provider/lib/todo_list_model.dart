// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:change_notifier_provider_sample/models.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

enum VisibilityFilter { all, active, completed }

class TodoListModel extends ChangeNotifier {
  final TodosRepository repository;

  VisibilityFilter _filter;

  VisibilityFilter get filter => _filter;

  set filter(VisibilityFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  List<Todo> _todos;

  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  TodoListModel({
    @required this.repository,
    VisibilityFilter filter,
    List<Todo> todos,
  })  : _todos = todos ?? [],
        _filter = filter ?? VisibilityFilter.all;

  /// Loads remote data
  ///
  /// Call this initially and when the user manually refreshes
  Future loadTodos() {
    _isLoading = true;
    notifyListeners();

    return repository.loadTodos().then((loadedTodos) {
      _todos.addAll(loadedTodos.map(Todo.fromEntity));
      _isLoading = false;
      notifyListeners();
    }).catchError((err) {
      _isLoading = false;
      notifyListeners();
    });
  }

  List<Todo> get filteredTodos {
    return _todos.where((todo) {
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
  }

  void clearCompleted() {
    _todos.removeWhere((todo) => todo.complete);
    notifyListeners();
    _uploadItems();
  }

  void toggleAll() {
    var allComplete = todos.every((todo) => todo.complete);
    _todos = _todos.map((todo) => todo.copy(complete: !allComplete)).toList();
    notifyListeners();
    _uploadItems();
  }

  /// updates a [Todo] by replacing the item with the same id by the parameter [todo]
  void updateTodo(Todo todo) {
    assert(todo != null);
    assert(todo.id != null);
    var oldTodo = _todos.firstWhere((it) => it.id == todo.id);
    var replaceIndex = _todos.indexOf(oldTodo);
    _todos.replaceRange(replaceIndex, replaceIndex + 1, [todo]);
    notifyListeners();
    _uploadItems();
  }

  void removeTodo(Todo todo) {
    _todos.removeWhere((it) => it.id == todo.id);
    notifyListeners();
    _uploadItems();
  }

  void addTodo(Todo todo) {
    _todos.add(todo);
    notifyListeners();
    _uploadItems();
  }

  void _uploadItems() {
    repository.saveTodos(_todos.map((it) => it.toEntity()).toList());
  }

  Todo todoById(String id) {
    return _todos.firstWhere((it) => it.id == id, orElse: () => null);
  }

  int get numCompleted =>
      todos.where((Todo todo) => todo.complete).toList().length;

  bool get hasCompleted => numCompleted > 0;

  int get numActive =>
      todos.where((Todo todo) => !todo.complete).toList().length;

  bool get hasActiveTodos => numActive > 0;
}
