import 'package:bloc_library/models/models.dart';
import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';

class DeleteTodoSnackBar extends SnackBar {
  final ArchSampleLocalizations localizations;

  DeleteTodoSnackBar({
    super.key,
    required Todo todo,
    required VoidCallback onUndo,
    required this.localizations,
    super.duration = const Duration(seconds: 2),
  }) : super(
         content: Text(
           localizations.todoDeleted(todo.task),
           maxLines: 1,
           overflow: TextOverflow.ellipsis,
         ),
         action: SnackBarAction(label: localizations.undo, onPressed: onUndo),
       );
}
