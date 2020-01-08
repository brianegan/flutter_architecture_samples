// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scoped_model_sample/models.dart';
import 'package:scoped_model_sample/todo_list_model.dart';

class ExtraActionsButton extends StatelessWidget {
  ExtraActionsButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TodoListModel>(
        builder: (BuildContext context, Widget child, TodoListModel model) {
      return PopupMenuButton<ExtraAction>(
        key: ArchSampleKeys.extraActionsButton,
        onSelected: (action) {
          if (action == ExtraAction.toggleAllComplete) {
            model.toggleAll();
          } else if (action == ExtraAction.clearCompleted) {
            model.clearCompleted();
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuItem<ExtraAction>>[
          PopupMenuItem<ExtraAction>(
            key: ArchSampleKeys.toggleAll,
            value: ExtraAction.toggleAllComplete,
            child: Text(model.todos.any((it) => !it.complete)
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
    });
  }
}
