import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';

enum ExtraAction { toggleAll, clearCompleted }

Widget buildExtraActionsMenu<TMsg>(
    void onSelected(ExtraAction action), bool allComplete) {

  return new PopupMenuButton<ExtraAction>(
    key: ArchSampleKeys.extraActionsButton,
    onSelected: onSelected,
    itemBuilder: (BuildContext context) => <PopupMenuItem<ExtraAction>>[
          new PopupMenuItem<ExtraAction>(
            key: ArchSampleKeys.toggleAll,
            value: ExtraAction.toggleAll,
            child: new Text(allComplete
                ? ArchSampleLocalizations.of(context).markAllIncomplete
                : ArchSampleLocalizations.of(context).markAllComplete),
          ),
          new PopupMenuItem<ExtraAction>(
            key: ArchSampleKeys.clearCompleted,
            value: ExtraAction.clearCompleted,
            child: new Text(ArchSampleLocalizations.of(context).clearCompleted),
          ),
        ],
  );
}