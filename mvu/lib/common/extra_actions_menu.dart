import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';

enum ExtraAction { toggleAll, clearCompleted }

Widget buildExtraActionsMenu<TMsg>(
    void Function(ExtraAction action) onSelected, bool allComplete) {
  return PopupMenuButton<ExtraAction>(
    key: ArchSampleKeys.extraActionsButton,
    onSelected: onSelected,
    itemBuilder: (BuildContext context) => <PopupMenuItem<ExtraAction>>[
      PopupMenuItem<ExtraAction>(
        key: ArchSampleKeys.toggleAll,
        value: ExtraAction.toggleAll,
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
