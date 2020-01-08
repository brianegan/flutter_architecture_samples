import 'package:dartea/dartea.dart';
import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';

ScaffoldState _scaffoldState;

void init(BuildContext context) {
  _scaffoldState = Scaffold.of(context);
}

Cmd<TMsg> showUndoCmd<TMsg>(String task, TMsg Function() onUndo) {
  return Cmd.ofEffect((Dispatch<TMsg> dispatch) {
    _scaffoldState.showSnackBar(
      SnackBar(
        key: ArchSampleKeys.snackbar,
        duration: Duration(seconds: 2),
        content: Text(
          ArchSampleLocalizations.of(_scaffoldState.context).todoDeleted(task),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        action: SnackBarAction(
          label: ArchSampleLocalizations.of(_scaffoldState.context).undo,
          onPressed: () => dispatch(onUndo()),
        ),
      ),
    );
  });
}
