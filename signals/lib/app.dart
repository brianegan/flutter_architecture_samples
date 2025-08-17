import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals_sample/todo_list_controller.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

import 'add_todo_screen.dart';
import 'home/home_screen.dart';
import 'localization.dart';
import 'todo.dart';

class SignalsApp extends StatelessWidget {
  final TodosRepository repository;

  const SignalsApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return Provider<TodoListController>(
      create: (_) => TodoListController(todosRepository: repository)..init(),
      dispose: (_, controller) => controller.dispose(),
      child: MaterialApp(
        theme: ArchSampleTheme.theme,
        localizationsDelegates: [
          ArchSampleLocalizationsDelegate(),
          SignalsLocalizationsDelegate(),
        ],
        onGenerateTitle: (context) => SignalsLocalizations.of(context).appTitle,
        routes: {
          ArchSampleRoutes.home: (context) => HomeScreen(),
          ArchSampleRoutes.addTodo: (context) => AddTodoScreen(
            onAdd: (Todo todo) {
              context.read<TodoListController>().todos.add(todo);

              Navigator.pop(context);
            },
          ),
        },
      ),
    );
  }
}
