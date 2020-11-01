// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:core';

import 'package:path_provider/path_provider.dart';
import 'package:rvms_model_sample/display_todos/_model/todo.dart';
import 'package:rvms_model_sample/display_todos/_services/repository_service_.dart';
import 'package:todos_repository_core/todos_repository_core.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

/// A class that glues together our local file storage and web client. It has a
/// clear responsibility: Load Todos and Persist todos.
///
/// In most apps, we use the provided repository. In this case, it makes sense
/// to demonstrate the built_value serializers, which are used in the
/// FileStorage part of this app.
///
/// Please see the `todos_repository` library for more information about the
/// Repository pattern.
class RepositoryServiceImplementation implements RepositoryService {
  final FileStorage fileStorage;
  final WebClient webClient;

  const RepositoryServiceImplementation({
    this.fileStorage = const FileStorage(
      '__built_redux_sample_app__',
      getApplicationDocumentsDirectory,
    ),
    this.webClient = const WebClient(),
  });

  /// Loads todos first from File storage. If they don't exist or encounter an
  /// error, it attempts to load the Todos from a Web Service.
  @override
  Future<List<Todo>> loadTodos() async {
    List<TodoEntity> loadedTodos;
    try {
      loadedTodos = await fileStorage.loadTodos();
    } catch (e) {
      loadedTodos = await webClient.loadTodos();
    }
    return loadedTodos.map(Todo.fromEntity).toList();
  }

  // Persists todos to local disk and the web
  @override
  Future saveTodos(List<Todo> todos) {
    final todoEntities = todos.map((it) => it.toEntity()).toList();
    return Future.wait([
      fileStorage.saveTodos(todoEntities),
      webClient.saveTodos(todoEntities),
    ]);
  }
}
