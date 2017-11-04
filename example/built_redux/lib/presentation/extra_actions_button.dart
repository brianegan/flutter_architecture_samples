import 'package:built_redux_sample/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';

class ExtraActionsButton extends StatelessWidget {
  final PopupMenuItemSelected<ExtraAction> onSelected;
  final bool allComplete;

  ExtraActionsButton({
    this.onSelected,
    this.allComplete = false,
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
                  ? ArchSampleLocalizations.of(context).markAllIncomplete
                  : ArchSampleLocalizations.of(context).markAllComplete),
            ),
            new PopupMenuItem<ExtraAction>(
              value: ExtraAction.clearCompleted,
              child: new Text(
                  ArchSampleLocalizations.of(context).clearCompleted),
            ),
          ],
    );
  }
}
