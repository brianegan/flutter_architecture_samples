import 'package:binder_sample/logics/todos.dart';
import 'package:binder_sample/models.dart';
import 'package:flutter/material.dart';
import 'package:binder/binder.dart';
import 'package:todos_app_core/todos_app_core.dart';

extension ScaffoldMessengerStateX on ScaffoldMessengerState {
  void showDeleteTodoSnackBar(Todo todo) {
    hideCurrentSnackBar();
    showSnackBar(createDeleteTodoSnackBar(context, todo));
  }
}

SnackBar createDeleteTodoSnackBar(BuildContext context, Todo todo) {
  final todosLogic = context.use(todosLogicRef);
  return SnackBar(
    key: ArchSampleKeys.snackbar,
    duration: const Duration(seconds: 2),
    content: Text(
      ArchSampleLocalizations.of(context).todoDeleted(todo.task),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    action: SnackBarAction(
      key: ArchSampleKeys.snackbarAction(todo.id),
      label: ArchSampleLocalizations.of(context).undo,
      onPressed: () => todosLogic.add(todo),
    ),
  );
}
