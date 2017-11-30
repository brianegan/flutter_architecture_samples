import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scoped_model_sample/localization.dart';
import 'package:scoped_model_sample/screens/add_edit_screen.dart';
import 'package:scoped_model_sample/screens/home_screen.dart';
import 'package:scoped_model_sample/todo_list_model.dart';
import 'package:todos_repository/src/repository.dart';

class ScopedModelApp extends StatelessWidget {
  final TodosRepository repository;

  ScopedModelApp({
    @required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    var app = new MaterialApp(
      title: new ScopedModelLocalizations().appTitle,
      theme: ArchSampleTheme.theme,
      localizationsDelegates: [
        new ArchSampleLocalizationsDelegate(),
        new ScopedModelLocalizationsDelegate(),
      ],
      routes: {
        ArchSampleRoutes.home: (context) => new HomeScreen(),
        ArchSampleRoutes.addTodo: (context) => new AddEditScreen(),
      },
    );

    return new ScopedModel<TodoListModel>(
      model: new TodoListModel(
        repository: repository,
      ),
      child: app,
    );
  }
}
