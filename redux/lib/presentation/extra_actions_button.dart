import 'package:flutter/material.dart';
import 'package:redux_sample/models/models.dart';
import 'package:todos_app_core/todos_app_core.dart';

class ExtraActionsButton extends StatelessWidget {
  final PopupMenuItemSelected<ExtraAction> onSelected;
  final bool allComplete;

  const ExtraActionsButton({
    super.key = ArchSampleKeys.extraActionsButton,
    required this.onSelected,
    this.allComplete = false,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ExtraAction>(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => <PopupMenuItem<ExtraAction>>[
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
      ],
    );
  }
}
