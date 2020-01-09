// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:core';

import 'package:meta/meta.dart';
import 'package:todos_repository_core/todos_repository_core.dart';
import 'package:todos_repository_simple/src/local_storage.dart';

import 'web_client.dart';

/// A class that glues together our local storage and web client. It has a
/// clear responsibility: Load Todos and Persist todos.
///
/// It interacts with the LocalStorage class which can be used for either web
/// or mobile.
class LocalStorageRepository implements TodosRepository {
  final LocalStorage localStorage;
  final WebClient webClient;

  const LocalStorageRepository({
    @required this.localStorage,
    this.webClient = const WebClient(),
  });

  /// Loads todos first from File storage. If they don't exist or encounter an
  /// error, it attempts to load the Todos from a Web Client.
  @override
  Future<List<TodoEntity>> loadTodos() async {
    try {
      return localStorage.loadTodos();
    } catch (e) {
      final todos = await webClient.fetchTodos();

      await localStorage.saveTodos(todos);

      return todos;
    }
  }

  // Persists todos to local disk and the web
  @override
  Future<List<bool>> saveTodos(List<TodoEntity> todos) {
    return Future.wait<bool>([
      localStorage.saveTodos(todos),
      webClient.postTodos(todos),
    ]);
  }
}
