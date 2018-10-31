// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
//import 'package:scoped_model/scoped_model.dart';
import 'package:scoped_model_sample/models.dart';
import 'package:scoped_model_sample/todo_list_model.dart';

import 'package:mvc/src/Controller.dart';

class ExtraActionsButton extends StatelessWidget {
  ExtraActionsButton({
    Key key,
  }) : super(key: key);

  final con = Con.con;

  @override
  Widget build(BuildContext context) {
//    var model = TodoListModel.of(context, rebuildOnChange: true);
    return PopupMenuButton<ExtraAction>(
      key: ArchSampleKeys.extraActionsButton,
      onSelected: (action) {
        if (action == ExtraAction.toggleAllComplete) {
          con.toggle();
        } else if (action == ExtraAction.clearCompleted) {
          /// The View nor the Conttoller need not know what's involved.
          con.clear();
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<ExtraAction>>[
            PopupMenuItem<ExtraAction>(
              key: ArchSampleKeys.toggleAll,
              value: ExtraAction.toggleAllComplete,
              child: Text(Con.todos.any((it) => !it['complete'])
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
}
