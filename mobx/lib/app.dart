import 'package:flutter/material.dart';
import 'package:mobx_sample/add_todo_screen.dart';
import 'package:mobx_sample/localization.dart';
import 'package:mobx_sample/models/todo.dart';
import 'package:mobx_sample/stores/todo_store.dart';
import 'package:provider/provider.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

import 'home/home_screen.dart';

class MobxApp extends StatelessWidget {
  final TodosRepository repository;

  const MobxApp({Key key, @required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<TodoStore>(
      create: (_) {
        final store = TodoStore(repository)..init();

        return store;
      },
      dispose: (_, store) => store.dispose(), // Clean up after we're done
      child: MaterialApp(
        initialRoute: ArchSampleRoutes.home,
        theme: ArchSampleTheme.theme,
        localizationsDelegates: [
          MobxLocalizationsDelegate(),
          ArchSampleLocalizationsDelegate(),
        ],
        routes: {
          ArchSampleRoutes.home: (context) => const HomeScreen(),
          ArchSampleRoutes.addTodo: (context) {
            return AddTodoScreen(
              onAdd: (Todo todo) {
                Provider.of<TodoStore>(context, listen: false).todos.add(todo);
                Navigator.pop(context);
              },
            );
          }
        },
      ),
    );
  }
}
