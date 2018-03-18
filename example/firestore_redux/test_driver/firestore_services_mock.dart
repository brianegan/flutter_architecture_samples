// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_redux_sample/firestore_service.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:todos_repository/src/web_client.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirestore extends Mock implements Firestore {}

class MockFirestoreServices implements FirestoreService {
  final auth = new MockFirebaseAuth();
  final firestore = new MockFirestore();
  final controller = new StreamController<List<Todo>>(); // ignore: close_sinks
  List<Todo> todos;

  @override
  Future<UserInfo> anonymousLogin([
    delayAuth = const Duration(milliseconds: 1000),
  ]) {
    return new Future<FirebaseUser>.delayed(delayAuth);
  }

  @override
  Stream<List<Todo>> todosListener({webClient = const WebClient()}) async* {
    todos = await webClient.fetchTodos();

    yield todos;

    await for (var latest in controller.stream) {
      yield latest;
    }
  }

  @override
  Future<void> addNewTodo(Todo newTodo) async {
    todos.add(newTodo);
    controller.add(todos);
  }

  @override
  Future<List<void>> deleteTodo(List<String> idList) async {
    todos.removeWhere((todo) => idList.contains(todo.id));
    controller.add(todos);

    return [];
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    todos[todos.indexWhere((t) => t.id == todo.id)] = todo;

    controller.add(todos);
  }
}
