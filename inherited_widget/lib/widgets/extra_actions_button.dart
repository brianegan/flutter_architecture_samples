import 'package:flutter/material.dart';
import 'package:inherited_widget_sample/models.dart';
import 'package:todos_app_core/todos_app_core.dart';

class ExtraActionsButton extends StatelessWidget {
  final PopupMenuItemSelected<ExtraAction>? onSelected;
  final bool allComplete;
  final bool hasCompletedTodos;

  const ExtraActionsButton({
    super.key,
    this.onSelected,
    this.allComplete = false,
    this.hasCompletedTodos = true,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ExtraAction>(
      key: ArchSampleKeys.extraActionsButton,
      onSelected: onSelected,
      itemBuilder: (BuildContext context) {
        return <PopupMenuItem<ExtraAction>>[
          PopupMenuItem<ExtraAction>(
            key: ArchSampleKeys.toggleAll,
            value: ExtraAction.toggleAllComplete,
            child: Text(
              allComplete
                  ? ArchSampleLocalizations.of(context).markAllIncomplete
                  : ArchSampleLocalizations.of(context).markAllComplete,
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
