import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model_sample/app.dart';
import 'package:todos_repository/src/file_storage.dart';
import 'package:todos_repository/src/repository.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scoped_model_sample/todo_list_model.dart';

void main() {
  var todoRepo = const TodosRepository(
    fileStorage: const FileStorage(
      'scoped_model_todos',
      getApplicationDocumentsDirectory,
    ),
  );

  runApp(new ScopedModel<TodoListModel>(
    model: new TodoListModel(
      repository: todoRepo,
    ),
    child: new ScopedModelApp(),
  ));
}
