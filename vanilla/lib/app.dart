// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:todos_repository_core/todos_repository_core.dart';
import 'package:vanilla/localization.dart';
import 'package:vanilla/models.dart';
import 'package:vanilla/screens/add_edit_screen.dart';
import 'package:vanilla/screens/home_screen.dart';

class VanillaApp extends StatefulWidget {
  final TodosRepository repository;

  VanillaApp({@required this.repository});

  @override
  State<StatefulWidget> createState() {
    return VanillaAppState();
  }
}

class VanillaAppState extends State<VanillaApp> {
  AppState appState = AppState.loading();

  @override
  void initState() {
    super.initState();

    widget.repository.loadTodos().then((loadedTodos) {
      setState(() {
        appState = AppState(
          todos: loadedTodos.map(Todo.fromEntity).toList(),
        );
      });
    }).catchError((err) {
      setState(() {
        appState.isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => VanillaLocalizations.of(context).appTitle,
      theme: ArchSampleTheme.theme,
      localizationsDelegates: [
        ArchSampleLocalizationsDelegate(),
        VanillaLocalizationsDelegate(),
      ],
      routes: {
        ArchSampleRoutes.home: (context) {
          return HomeScreen(
            appState: appState,
            updateTodo: updateTodo,
            addTodo: addTodo,
            removeTodo: removeTodo,
            toggleAll: toggleAll,
            clearCompleted: clearCompleted,
          );
        },
        ArchSampleRoutes.addTodo: (context) {
          return AddEditScreen(
            key: ArchSampleKeys.addTodoScreen,
            addTodo: addTodo,
            updateTodo: updateTodo,
          );
        },
      },
    );
  }

  void toggleAll() {
    setState(() {
      appState.toggleAll();
    });
  }

  void clearCompleted() {
    setState(() {
      appState.clearCompleted();
    });
  }

  void addTodo(Todo todo) {
    setState(() {
      appState.todos.add(todo);
    });
  }

  void removeTodo(Todo todo) {
    setState(() {
      appState.todos.remove(todo);
    });
  }

  void updateTodo(
    Todo todo, {
    bool complete,
    String id,
    String note,
    String task,
  }) {
    setState(() {
      todo.complete = complete ?? todo.complete;
      todo.id = id ?? todo.id;
      todo.note = note ?? todo.note;
      todo.task = task ?? todo.task;
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);

    widget.repository.saveTodos(
      appState.todos.map((todo) => todo.toEntity()).toList(),
    );
  }
}
