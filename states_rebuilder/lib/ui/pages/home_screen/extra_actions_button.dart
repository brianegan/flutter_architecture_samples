import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:states_rebuilder_sample/service/todos_service.dart';
import 'package:states_rebuilder_sample/ui/common/enums.dart';
import 'package:todos_app_core/todos_app_core.dart';

class ExtraActionsButton extends StatelessWidget {
  ExtraActionsButton({Key key}) : super(key: key);
  final todosServiceRM = Injector.getAsReactive<TodosService>();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ExtraAction>(
      key: ArchSampleKeys.extraActionsButton,
      onSelected: (action) {
        if (action == ExtraAction.toggleAllComplete) {
          todosServiceRM.setState((s) => s.toggleAll());
        } else if (action == ExtraAction.clearCompleted) {
          todosServiceRM.setState((s) => s.clearCompleted());
        }
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuItem<ExtraAction>>[
          PopupMenuItem<ExtraAction>(
            key: ArchSampleKeys.toggleAll,
            value: ExtraAction.toggleAllComplete,
            child: Text(todosServiceRM.state.allComplete
                ? ArchSampleLocalizations.of(context).markAllIncomplete
                : ArchSampleLocalizations.of(context).markAllComplete),
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
