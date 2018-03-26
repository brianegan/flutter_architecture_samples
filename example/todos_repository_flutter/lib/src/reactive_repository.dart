// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:core';

import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:todos_repository/todos_repository.dart';

/// A class that glues together our local file storage and web client. It has a
/// clear responsibility: Load Todos and Persist todos.
class ReactiveTodosRepositoryFlutter implements ReactiveTodosRepository {
  final TodosRepository _repository;
  final BehaviorSubject<List<TodoEntity>> _subject;
  List<TodoEntity> _todos = [];
  bool _loaded = false;

  ReactiveTodosRepositoryFlutter({
    @required TodosRepository repository,
    BehaviorSubject<List<TodoEntity>> subject,
  })
      : this._repository = repository,
        this._subject = subject ?? new BehaviorSubject<List<TodoEntity>>();

  @override
  Future<void> addNewTodo(TodoEntity todo) async {
    _todos.add(todo);
    _subject.add(_todos);
    await _repository.saveTodos(_todos);
  }

  @override
  Future<void> deleteTodo(List<String> idList) async {
    _todos.removeWhere((todo) => idList.contains(todo.id));
    _subject.add(_todos);
    await _repository.saveTodos(_todos);
  }

  @override
  Stream<List<TodoEntity>> todos() {
    if (!_loaded) _loadTodos();

    return _subject.stream;
  }

  void _loadTodos() {
    _loaded = true;

    _repository.loadTodos().then(_todos.addAll).whenComplete(() {
      _subject.add(_todos);
    });
  }

  @override
  Future<void> updateTodo(TodoEntity todo) async {
    _todos[_todos.indexWhere((_todo) => _todo.id == todo.id)] = todo;
    _subject.add(_todos);
    await _repository.saveTodos(_todos);
  }
}
