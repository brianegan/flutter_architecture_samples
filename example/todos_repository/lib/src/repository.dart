import 'dart:async';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:todos_repository/src/file_storage.dart';
import 'package:todos_repository/src/todo_entity.dart';
import 'package:todos_repository/src/web_client.dart';

/// A class that glues together our local file storage and web client. It has a
/// clear responsibility: Load Todos and Persist todos.
///
/// How and where it stores the entities should confined to this layer, and the
/// Domain layer of your app should only access this repository, not a database
/// or the web directly.
class TodosRepository {
  final FileStorage fileStorage;
  final WebClient webClient;

  const TodosRepository({
    @required this.fileStorage,
    this.webClient = const WebClient(),
  });

  /// Loads todos first from File storage. If they don't exist or encounter an
  /// error, it attempts to load the Todos from a Web Client.
  Future<List<TodoEntity>> loadTodos() async {
    try {
      return await fileStorage.loadTodos();
    } catch (e) {
      return webClient.fetchTodos();
    }
  }

  // Persists todos to local disk and the web
  Future saveTodos(List<TodoEntity> todos) {
    return Future.wait([
      fileStorage.saveTodos(todos),
      webClient.postTodos(todos),
    ]);
  }
}
