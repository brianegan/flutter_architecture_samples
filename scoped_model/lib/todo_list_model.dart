// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scoped_model_sample/models.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

class TodoListModel extends Model {
  final TodosRepository repository;

  VisibilityFilter _activeFilter;

  VisibilityFilter get activeFilter => _activeFilter;

  set activeFilter(VisibilityFilter filter) {
    _activeFilter = filter;
    notifyListeners();
  }

  List<Todo> get todos => _todos.toList();

  List<Todo> _todos = [];

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  TodoListModel({@required this.repository, VisibilityFilter activeFilter})
      : _activeFilter = activeFilter ?? VisibilityFilter.all;

  /// Wraps [ScopedModel.of] for this [Model]. See [ScopedModel.of] for more
  static TodoListModel of(BuildContext context) =>
      ScopedModel.of<TodoListModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    // update data for every subscriber, especially for the first one
    loadTodos();
  }

  /// Loads remote data
  ///
  /// Call this initially and when the user manually refreshes
  Future loadTodos() {
    _isLoading = true;
    notifyListeners();

    return repository.loadTodos().then((loadedTodos) {
      _todos = loadedTodos.map(Todo.fromEntity).toList();
      _isLoading = false;
      notifyListeners();
    }).catchError((err) {
      _isLoading = false;
      _todos = [];
      notifyListeners();
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
    notifyListeners();
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
}

enum VisibilityFilter { all, active, completed }
