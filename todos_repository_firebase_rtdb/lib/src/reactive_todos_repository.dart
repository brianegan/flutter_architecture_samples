// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

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

  @override
  Stream<List<TodoEntity>> todos() {
    return firebase.reference().child(path).onValue.map((event) {
      if (event.snapshot == null || event.snapshot.value == null) return [];
      final Map<dynamic, dynamic> value = event.snapshot.value;
      final todoMap = value.map((key, doc) {
        return MapEntry(
            key,
            TodoEntity(
              doc['task'],
              key,
              doc['note'] ?? '',
              doc['complete'] ?? false,
            ));
      });
      return todoMap.values.toList();
    });
  }

  @override
  Future<void> updateTodo(TodoEntity todo) {
    return firebase.reference().child(path).child(todo.id).set(todo.toJson());
  }
}
