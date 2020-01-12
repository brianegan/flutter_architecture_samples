import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:todos_app_core/todos_app_core.dart';

import '../../domain/entities/todo.dart';
import '../../service/todos_service.dart';

class HelperMethods {
  static void removeTodo(Todo todo) {
    final todosServiceRM = Injector.getAsReactive<TodosService>();
    todosServiceRM.setState(
      (s) => s.deleteTodo(todo),
      onSetState: (context) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            key: ArchSampleKeys.snackbar,
            duration: Duration(seconds: 2),
            content: Text(
              ArchSampleLocalizations.of(context).todoDeleted(todo.task),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            action: SnackBarAction(
              label: ArchSampleLocalizations.of(context).undo,
              onPressed: () {
                todosServiceRM.setState((s) => s.addTodo(todo));
              },
            ),
          ),
        );
      },
    );
  }
}
