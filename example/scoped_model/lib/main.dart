import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model_sample/app.dart';
import 'package:todos_repository/src/file_storage.dart';
import 'package:todos_repository/src/repository.dart';

void main() {
  var todoRepo = const TodosRepository(
    fileStorage: const FileStorage(
      'scoped_model_todos',
      getApplicationDocumentsDirectory,
    ),
  );

  runApp(new ScopedModelApp(
    repository: todoRepo,
  ));
}
