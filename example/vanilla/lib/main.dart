import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:vanilla/app.dart';

void main() {
  runApp(
    new VanillaApp(
      repository: new TodosRepository(
        fileStorage: new FileStorage(
          "vanilla_app",
          getApplicationDocumentsDirectory,
        ),
        webClient: new WebClient(),
      ),
    ),
  );
}
