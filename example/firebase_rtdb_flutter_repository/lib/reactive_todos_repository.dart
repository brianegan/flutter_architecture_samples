// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:todos_repository/todos_repository.dart';

class FirebaseReactiveTodosRepository implements ReactiveTodosRepository {
  static const String path = 'todo';

  final FirebaseDatabase firebase;
  DatabaseReference todosReference;

  FirebaseReactiveTodosRepository(this.firebase) {
    todosReference = firebase.reference().child(path);
  }

  @override
  Future<void> addNewTodo(TodoEntity todo) {
    return updateTodo(todo);
  }

  @override
  Future<void> deleteTodo(List<String> idList) async {
    await Future.wait<void>(idList.map((id) {
      return todosReference.child(id).set(null);
    }));
  }

  @override
  Stream<List<TodoEntity>> todos() {
    return todosReference.onValue.map((event) {
      List<TodoEntity> todos = [];
      if (event.snapshot != null && event.snapshot.value != null) {
        event.snapshot.value.forEach((k, v) {
          Map<String, dynamic> todoMap = {};
          convertSnapshotValueToJsonMap(v, todoMap);
          TodoEntity todoEntity = TodoEntity(
            todoMap['task'],
            todoMap['id'],
            todoMap['note'] ?? '',
            todoMap['complete'] ?? false,
          );
          todos.add(todoEntity);
        });
      }
      return todos;
    });
  }

  @override
  Future<void> updateTodo(TodoEntity todo) {
    return todosReference.child(todo.id).set(todo.toJson());
  }

  void convertSnapshotValueToJsonMap(Map value, Map<String, dynamic> jsonMap) {
    value.forEach((k, v) {
      jsonMap[k] = v;
    });
  }
}
