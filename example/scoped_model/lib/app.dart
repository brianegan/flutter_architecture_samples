import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scoped_model_sample/localization.dart';
import 'package:scoped_model_sample/screens/add_edit_screen.dart';
import 'package:scoped_model_sample/screens/detail_screen.dart';
import 'package:scoped_model_sample/screens/home_screen.dart';
import 'package:scoped_model_sample/todo_list_model.dart';
import 'package:todos_repository/src/repository.dart';
import 'package:scoped_model_sample/models.dart';

class ScopedModelApp extends StatelessWidget {
  ScopedModelApp();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: new ScopedModelLocalizations().appTitle,
      theme: ArchSampleTheme.theme,
      onGenerateRoute: (settings) {
        final detailRoute = '/detail/';
        if (settings.name.startsWith(detailRoute)) {
          final todo = new ModelFinder<TodoListModel>()
                  .of(context)
                  .todoById(settings.name.replaceFirst(detailRoute, '')) ??
              new TodoModel('Oh nooooooo');

          return new MaterialPageRoute(
            builder: (_) {
              return new ScopedModel<TodoModel>(
                model: todo,
                child: new DetailScreen(),
              );
            },
          );
        }
      },
      localizationsDelegates: [
        new ArchSampleLocalizationsDelegate(),
        new ScopedModelLocalizationsDelegate(),
      ],
      routes: {
        ArchSampleRoutes.home: (context) => new HomeScreen(),
        ArchSampleRoutes.addTodo: (context) => new AddEditScreen(),
      },
    );
  }
}
