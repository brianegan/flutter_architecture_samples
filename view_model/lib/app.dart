import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:todos_repository_core/todos_repository_core.dart';
import 'package:view_model/view_model.dart';

import 'add_todo_screen.dart';
import 'home/home_screen.dart';
import 'localization.dart';
import 'todo.dart';
import 'todo_list_view_model.dart';

class ViewModelApp extends StatefulWidget {
  final TodosRepository repository;

  const ViewModelApp({super.key, required this.repository});

  @override
  State<ViewModelApp> createState() => _ViewModelAppState();
}

class _ViewModelAppState extends State<ViewModelApp>
    with ViewModelStateMixin<ViewModelApp> {
  TodoListViewModel get todoListViewModel =>
      viewModelBinding.read(todoListViewModelSpec(widget.repository));

  @override
  void initState() {
    super.initState();
    unawaited(todoListViewModel.initialize());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ArchSampleTheme.lightTheme,
      darkTheme: ArchSampleTheme.darkTheme,
      navigatorObservers: [ViewModel.routeObserver],
      localizationsDelegates: [
        ArchSampleLocalizationsDelegate(),
        ViewModelLocalizationsDelegate(),
      ],
      onGenerateTitle: (context) => ViewModelLocalizations.of(context).appTitle,
      routes: {
        ArchSampleRoutes.home: (_) => HomeScreen(repository: widget.repository),
        ArchSampleRoutes.addTodo: (context) => AddTodoScreen(
          onAdd: (Todo todo) {
            unawaited(todoListViewModel.addTodo(todo));
            Navigator.pop(context);
          },
        ),
      },
    );
  }
}
