// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static const String path = 'todo';

  final FirebaseAuth auth;
  final Firestore firestore;

  const FirestoreService(this.auth, this.firestore);

  Future<void> addNewTodo(Todo todo) {
    return firestore.collection(path).document(todo.id).setData(todo.toMap());
  }

  Future<UserInfo> anonymousLogin() {
    return auth.signInAnonymously();
  }

  Future<List<void>> deleteTodo(List<String> idList) {
    return Future.wait(idList.map((id) {
      return firestore.collection(path).document(id).delete();
    }));
  }

  Stream<List<Todo>> todosListener() {
    return firestore.collection(path).snapshots.map((snapshot) {
      return snapshot.documents.map(Todo.fromDocument);
    });
  }

  Future<void> updateTodo(Todo todo) {
    return firestore
        .collection(path)
        .document(todo.id)
        .updateData(todo.toMap());
  }
}
