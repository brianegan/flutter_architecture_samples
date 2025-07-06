import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:vanilla/models.dart';

class ExtraActionsButton extends StatelessWidget {
  final PopupMenuItemSelected<ExtraAction> onSelected;
  final bool allComplete;
  final bool hasCompletedTodos;

  const ExtraActionsButton({
    required this.onSelected,
    this.allComplete = false,
    this.hasCompletedTodos = true,
    super.key = ArchSampleKeys.extraActionsButton,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ExtraAction>(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => <PopupMenuItem<ExtraAction>>[
        PopupMenuItem<ExtraAction>(
          key: ArchSampleKeys.toggleAll,
          value: ExtraAction.toggleAllComplete,
          child: Text(allComplete
              ? ArchSampleLocalizations.of(context).markAllIncomplete
              : ArchSampleLocalizations.of(context).markAllComplete),
        ),
        PopupMenuItem<ExtraAction>(
          key: ArchSampleKeys.clearCompleted,
          value: ExtraAction.clearCompleted,
          child: Text(ArchSampleLocalizations.of(context).clearCompleted),
        ),
      ],
    );
  }
}
