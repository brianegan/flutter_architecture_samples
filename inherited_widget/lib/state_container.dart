// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inherited_widget_sample/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:todos_repository_flutter/todos_repository_flutter.dart';

class StateContainer extends StatefulWidget {
  final AppState state;
  final TodosRepository repository;
  final Widget child;

  StateContainer({
    @required this.child,
    this.repository = const TodosRepositoryFlutter(
      fileStorage: const FileStorage(
        'inherited_widget_sample',
        getApplicationDocumentsDirectory,
      ),
    ),
    this.state,
  });

  static StateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
            as _InheritedStateContainer)
        .data;
  }

  @override
  State<StatefulWidget> createState() {
    return StateContainerState();
  }
}

class StateContainerState extends State<StateContainer> {
  AppState state;

  @override
  void initState() {
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = AppState.loading();
    }

    widget.repository.loadTodos().then((loadedTodos) {
      setState(() {
        state = AppState(
          todos: loadedTodos.map(Todo.fromEntity).toList(),
        );
      });
    }).catchError((err) {
      setState(() {
        state.isLoading = false;
      });
    });

    super.initState();
  }

  void toggleAll() {
    setState(() {
      state.toggleAll();
    });
  }

  void clearCompleted() {
    setState(() {
      state.clearCompleted();
    });
  }

  void addTodo(Todo todo) {
    setState(() {
      state.todos.add(todo);
    });
  }

  void removeTodo(Todo todo) {
    setState(() {
      state.todos.remove(todo);
    });
  }

  void updateFilter(VisibilityFilter filter) {
    setState(() {
      state.activeFilter = filter;
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

    widget.repository
        .saveTodos(state.todos.map((todo) => todo.toEntity()).toList());
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final StateContainerState data;

  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  // Note: we could get fancy here and compare whether the old AppState is
  // different than the current AppState. However, since we know this is the
  // root Widget, when we make changes we also know we want to rebuild Widgets
  // that depend on the StateContainer.
  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}

typedef TodoUpdater(
  Todo todo, {
  bool complete,
  String id,
  String note,
  String task,
});
