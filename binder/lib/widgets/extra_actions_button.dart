// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:binder/binder.dart';
import 'package:binder_sample/logics/home_screen.dart';
import 'package:binder_sample/logics/todos.dart';
import 'package:binder_sample/models.dart';
import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';

class ExtraActionsButton extends StatelessWidget {
  const ExtraActionsButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allComplete = context.watch(
        todosRef.select((todos) => todos.every((todo) => todo.complete)));
    return PopupMenuButton<ExtraAction>(
      key: ArchSampleKeys.extraActionsButton,
      onSelected: (action) {
        switch (action) {
          case ExtraAction.clearCompleted:
            context.use(homeScreenLogicRef).clearCompleted();
            break;
          case ExtraAction.toggleAllComplete:
            context.use(homeScreenLogicRef).toggleAll();
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<ExtraAction>>[
        PopupMenuItem<ExtraAction>(
          key: ArchSampleKeys.toggleAll,
          value: ExtraAction.toggleAllComplete,
          child: Text(allComplete
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
