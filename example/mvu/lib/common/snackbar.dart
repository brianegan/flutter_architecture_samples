import 'package:flutter/material.dart';
import 'package:dartea/dartea.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';

ScaffoldState _scaffoldState;

void init(BuildContext context) {
  _scaffoldState = Scaffold.of(context);
}

Cmd<TMsg> showUndoCmd<TMsg>(String task, TMsg onUndo()) {
  return new Cmd.ofEffect((Dispatch<TMsg> dispatch) {
    _scaffoldState.showSnackBar(
      new SnackBar(
        key: ArchSampleKeys.snackbar,
        duration: new Duration(seconds: 2),
        backgroundColor: Theme.of(_scaffoldState.context).backgroundColor,
        content: new Text(
          ArchSampleLocalizations.of(_scaffoldState.context).todoDeleted(task),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        action: new SnackBarAction(
          label: ArchSampleLocalizations.of(_scaffoldState.context).undo,
          onPressed: () => dispatch(onUndo()),
        ),
      ),
    );
  });
}
