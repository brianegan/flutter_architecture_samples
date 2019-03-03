import 'package:flutter/material.dart';

import 'package:todos_app_core/todos_app_core.dart';

import 'package:frideos/frideos.dart';

import 'package:frideos_library/app_state.dart';
import 'package:frideos_library/models/models.dart';

class ExtraActionsButton extends StatelessWidget {
  final bool allComplete;

  ExtraActionsButton({
    this.allComplete = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ExtraAction>(
      key: ArchSampleKeys.extraActionsButton,
      onSelected: AppStateProvider.of<AppState>(context).todosBloc.extraAction,
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
            child: Text(
              ArchSampleLocalizations.of(context).clearCompleted,
            ),
          ),
        ];
      },
    );
  }
}
