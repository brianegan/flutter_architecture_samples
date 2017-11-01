import 'dart:async';
import 'dart:core';
import 'package:redux_sample/data/file_storage.dart';
import 'package:redux_sample/data/web_service.dart';
import 'package:redux_sample/models.dart';

/// A class that glues together our local file storage and a remote web service.
class TodosService {
  final FileStorage fileStorage;
  final WebService webService;

  const TodosService({
    this.fileStorage = const FileStorage('__redux__'),
    this.webService = const WebService(),
  });

  /// Loads todos first from File storage. If they don't exist or encounter an
  /// error, it attempts to load the Todos from a Web Service.
  Future<List<Todo>> loadTodos() async {
    try {
      return await fileStorage.loadTodos();
    } catch (e) {
      return webService.fetchTodos();
    }
  }

  // Persists todos to local disk and the web
  Future saveTodos(List<Todo> todos) {
    return Future.wait([
      fileStorage.saveTodos(todos),
      webService.postTodos(todos),
    ]);
  }
}
