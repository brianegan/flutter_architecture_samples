// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:todos_repository/todos_repository.dart';

class FirebaseReactiveTodosRepository implements ReactiveTodosRepository {
  static const String path = 'todo';

  final FirebaseDatabase firebase;

  const FirebaseReactiveTodosRepository(this.firebase);

  @override
  Future<void> addNewTodo(TodoEntity todo) {
    return updateTodo(todo);
  }

  @override
  Future<void> deleteTodo(List<String> idList) async {
    await Future.wait<void>(idList.map((id) {
      return firebase.reference().child(path).child(id).set(null);
    }));
  }

//  @override
  Stream<List<TodoEntity>> xtodos() {
    return firebase.reference().child(path).onValue.map((event) {
      List<TodoEntity> todos = [];
      if (event.snapshot != null && event.snapshot.value != null) {
        event.snapshot.value.forEach((key, todoMap) {
          TodoEntity todoEntity = TodoEntity(
            todoMap['task'],
            key,
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
  Stream<List<TodoEntity>> todos() {
    return firebase.reference().child(path).onValue.map((event) {
      if (event.snapshot == null || event.snapshot.value == null) return [];
      return Map
          .castFrom(event.snapshot.value.map((key, doc) {
            return MapEntry(
                key,
                TodoEntity(
                  doc['task'],
                  key,
                  doc['note'] ?? '',
                  doc['complete'] ?? false,
                ));
          }))
          .values
          .toList()
          .cast();
    });
  }

  @override
  Future<void> updateTodo(TodoEntity todo) {
    return firebase.reference().child(path).child(todo.id).set(todo.toJson());
  }
}
