import 'package:flutter/material.dart';
import 'package:flutter_mvc/flutter_mvc.dart';
import 'package:vanilla/data/todos_service.dart';
import 'package:vanilla/models.dart';
import 'package:vanilla/screens/add_edit_screen.dart';
import 'package:vanilla/screens/tabs_screen.dart';
import 'package:vanilla/localization.dart';

class VanillaApp extends StatefulWidget {
  final TodosService service;

  VanillaApp({this.service});

  @override
  State<StatefulWidget> createState() {
    return new VanillaAppState();
  }
}

class VanillaAppState extends State<VanillaApp> {
  AppState appState = new AppState.loading();

  @override
  void initState() {
    super.initState();

    widget.service.loadTodos().then((loadedTodos) {
      setState(() {
        appState = new AppState(todos: loadedTodos);
      });
    }).catchError((err) {
      setState(() {
        appState.isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: new VanillaLocalizations().appTitle,
      theme: FlutterMvcTheme.theme,
      localizationsDelegates: [
        new ArchitectureLocalizationsDelegate(),
        new VanillaLocalizationsDelegate(),
      ],
      routes: {
        FlutterMvcRoutes.home: (context) {
          return new TabsScreen(
            appState: appState,
            updateFiler: updateFilter,
            updateTodo: updateTodo,
            updateTab: updateTab,
            addTodo: addTodo,
            removeTodo: removeTodo,
            toggleAll: toggleAll,
            clearCompleted: clearCompleted,
          );
        },
        FlutterMvcRoutes.addTodo: (context) {
          return new AddEditScreen(
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

  void updateTab(AppTab tab) {
    setState(() {
      appState.activeTab = tab;
    });
  }

  void updateFilter(VisibilityFilter filter) {
    setState(() {
      appState.activeFilter = filter;
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

    widget.service.saveTodos(appState.todos);
  }
}
