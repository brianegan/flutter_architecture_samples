import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_app_core/todos_app_core.dart';

import '../todo_list_controller.dart';

class ExtraActionsButton extends StatelessWidget {
  const ExtraActionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TodoListController>();

    return PopupMenuButton<ExtraAction>(
      key: ArchSampleKeys.extraActionsButton,
      onSelected: (action) {
        switch (action) {
          case ExtraAction.toggleAllComplete:
            controller.toggleAll();
            break;
          case ExtraAction.clearCompleted:
            controller.clearCompleted();
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuItem<ExtraAction>>[
          PopupMenuItem<ExtraAction>(
            key: ArchSampleKeys.toggleAll,
            value: ExtraAction.toggleAllComplete,
            child: Text(
              controller.hasPendingTodos.value
                  ? ArchSampleLocalizations.of(context).markAllComplete
                  : ArchSampleLocalizations.of(context).markAllIncomplete,
            ),
          ),
          PopupMenuItem<ExtraAction>(
            key: ArchSampleKeys.clearCompleted,
            value: ExtraAction.clearCompleted,
            child: Text(ArchSampleLocalizations.of(context).clearCompleted),
          ),
        ];
      },
    );
  }
}

enum ExtraAction { toggleAllComplete, clearCompleted }
