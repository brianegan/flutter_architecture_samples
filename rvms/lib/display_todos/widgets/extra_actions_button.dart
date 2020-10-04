// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:rvms_model_sample/display_todos/_manager/todo_manager_.dart';
import 'package:rvms_model_sample/display_todos/_model/typedefs.dart';
import 'package:todos_app_core/todos_app_core.dart';

class ExtraActionsButton extends StatelessWidget with GetItMixin {
  ExtraActionsButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allTodos = watchX((TodoManager x) => x.allTodos);

    return PopupMenuButton<ExtraAction>(
      key: ArchSampleKeys.extraActionsButton,
      onSelected: (action) {
        if (action == ExtraAction.toggleAllComplete) {
          get<TodoManager>().toggleAll();
        } else if (action == ExtraAction.clearCompleted) {
          get<TodoManager>().clearCompletedCommand();
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<ExtraAction>>[
        PopupMenuItem<ExtraAction>(
          key: ArchSampleKeys.toggleAll,
          value: ExtraAction.toggleAllComplete,
          child: Text(allTodos.any((it) => !it.complete)
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
