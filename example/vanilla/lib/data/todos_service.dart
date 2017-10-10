import 'dart:async';
import 'dart:core';
import 'package:vanilla/data/file_storage.dart';
import 'package:vanilla/data/web_service.dart';
import 'package:vanilla/models.dart';

/// A class that glues together our
class TodosService {
  final FileStorage fileStorage;
  final WebService webService;

  TodosService({this.fileStorage, this.webService});

  /// Loads todos first from File storage. If they don't exist or encounter an
  /// error, it attempts to load the Todos from a Web Service.
  Future<List<Todo>> loadTodos() async {
    try {
      return (await fileStorage.loadTodos());
    } catch (e) {
      return webService.fetchTodos();
    }
  }

  /// Attempts to persist the given todos to File Storage and the Web service.
  /// Returns true if everything worked, false if not.
  Future<bool> saveTodos(List<Todo> todos) async {
    try {
      // Run the operations in parallel.
      await Future.wait([
        fileStorage.saveTodos(todos),
        webService.postTodos(todos),
      ]);

      return true;
    } catch (e) {
      return false;
    }
  }
}
