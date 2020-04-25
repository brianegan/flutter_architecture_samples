import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:states_rebuilder_sample/service/todos_service.dart';
import 'package:states_rebuilder_sample/ui/common/enums.dart';
import 'package:states_rebuilder_sample/ui/exceptions/error_handler.dart';
import 'package:todos_app_core/todos_app_core.dart';

class ExtraActionsButton extends StatelessWidget {
  ExtraActionsButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //This is an example of local ReactiveModel
    return StateBuilder<ExtraAction>(
        //Create a reactiveModel of type  ExtraAction and set its initialValue to ExtraAction.clearCompleted)
        observe: () => RM.create(ExtraAction.clearCompleted),
        builder: (context, extraActionRM) {
          return PopupMenuButton<ExtraAction>(
            key: ArchSampleKeys.extraActionsButton,
            onSelected: (action) {
              //first set the value to the new action
              //See FilterButton where we use setValue there.
              extraActionRM.value = action;
              //then we use the getSetState to get the global registered ReactiveModel of TodosService
              //and call setState method.
              //There is one widget registered to the global ReactiveModel of TodosService, it is the
              //StateBuilder in the TodoList Widget.
              RM.getSetState<TodosService>(
                (s) async {
                  if (action == ExtraAction.toggleAllComplete) {
                    return s.toggleAll();
                  } else if (action == ExtraAction.clearCompleted) {
                    return s.clearCompleted();
                  }
                },
                //If and error happens, the global ReactiveModel of TodosService will notify listener widgets,
                //so that these widgets will display the origin state before calling onSelected method
                //and call showErrorSnackBar to show a snackBar
                onError: ErrorHandler.showErrorSnackBar,
              );
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<ExtraAction>>[
                PopupMenuItem<ExtraAction>(
                  key: ArchSampleKeys.toggleAll,
                  value: ExtraAction.toggleAllComplete,
                  child: Text(IN.get<TodosService>().allComplete
                      ? ArchSampleLocalizations.of(context).markAllIncomplete
                      : ArchSampleLocalizations.of(context).markAllComplete),
                ),
                PopupMenuItem<ExtraAction>(
                  key: ArchSampleKeys.clearCompleted,
                  value: ExtraAction.clearCompleted,
                  child:
                      Text(ArchSampleLocalizations.of(context).clearCompleted),
                ),
              ];
            },
          );
        });
  }
}
