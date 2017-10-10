import 'package:flutter/material.dart';
import 'package:flutter_mvc/flutter_mvc.dart';
import 'package:vanilla/models.dart';

class ExtraActionsButton extends StatelessWidget {
  final PopupMenuItemSelected<ExtraAction> onSelected;
  final bool allComplete;
  final bool hasCompletedTodos;

  ExtraActionsButton({
    this.onSelected,
    this.allComplete = false,
    this.hasCompletedTodos = true,
    Key key,
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new PopupMenuButton<ExtraAction>(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => <PopupMenuItem<ExtraAction>>[
            new PopupMenuItem<ExtraAction>(
              value: ExtraAction.toggleAllComplete,
              child: new Text(allComplete
                  ? ArchitectureLocalizations.of(context).markAllIncomplete
                  : ArchitectureLocalizations.of(context).markAllComplete),
            ),
            new PopupMenuItem<ExtraAction>(
              value: ExtraAction.clearCompleted,
              child: new Text(
                  ArchitectureLocalizations.of(context).clearCompleted),
            ),
          ],
    );
  }
}
