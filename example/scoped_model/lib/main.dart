import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model_sample/app.dart';
import 'package:scoped_model_sample/injector.dart';
import 'package:todos_repository/src/file_storage.dart';
import 'package:todos_repository/src/repository.dart';

void main() {
  runApp(new Injector(
    todoRepoFactory: singleton(todosRepository),
    child: new ScopedModelApp(),
  ));
}

TodosRepository todosRepository() {
  return const TodosRepository(
    fileStorage: const FileStorage(
      'scoped_model_todos',
      getApplicationDocumentsDirectory,
    ),
  );
}
