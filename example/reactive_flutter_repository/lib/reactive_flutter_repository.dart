// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todos_repository/todos_repository.dart';

class FlutterTodosReactiveRepository implements TodosReactiveRepository {
  static const String path = 'todo';

  final FirebaseAuth auth;
  final Firestore firestore;

  const FlutterTodosReactiveRepository(this.auth, this.firestore);

  @override
  Future<void> addNewTodo(TodoEntity todo) {
    return firestore.collection(path).document(todo.id).setData(todo.toJson());
  }

  @override
  Future<UserInfo> anonymousLogin() {
    return auth.signInAnonymously();
  }

  @override
  Future<List<void>> deleteTodo(List<String> idList) {
    return Future.wait(idList.map((id) {
      return firestore.collection(path).document(id).delete();
    }));
  }

  @override
  Stream<List<TodoEntity>> todos() {
    return firestore.collection(path).snapshots.map((snapshot) {
      return snapshot.documents.map((doc) {
        return new TodoEntity(
          doc['task'],
          doc.documentID,
          doc['note'] ?? '',
          doc['complete'] ?? false,
        );
      }).toList();
    });
  }

  @override
  Future<void> updateTodo(TodoEntity todo) {
    return firestore
        .collection(path)
        .document(todo.id)
        .updateData(todo.toJson());
  }
}
