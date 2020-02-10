// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_app_core/todos_app_core.dart';

import '../todo_list_model.dart';

class ExtraActionsButton extends StatelessWidget {
  const ExtraActionsButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TodoList>(context);

    return PopupMenuButton<ExtraAction>(
      key: ArchSampleKeys.extraActionsButton,
      onSelected: (action) {
        switch (action) {
          case ExtraAction.toggleAllComplete:
            context.read<TodoListController>().toggleAll();
            break;
          case ExtraAction.clearCompleted:
            context.read<TodoListController>().clearCompleted();
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuItem<ExtraAction>>[
          PopupMenuItem<ExtraAction>(
            key: ArchSampleKeys.toggleAll,
            value: ExtraAction.toggleAllComplete,
            child: Text(model.hasActiveTodos
                ? ArchSampleLocalizations.of(context).markAllComplete
                : ArchSampleLocalizations.of(context).markAllIncomplete),
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

enum ExtraAction { toggleAllComplete, clearCompleted }
