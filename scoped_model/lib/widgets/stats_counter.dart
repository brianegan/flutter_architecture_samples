// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scoped_model_sample/models.dart';
import 'package:scoped_model_sample/todo_list_model.dart';

class StatsCounter extends StatelessWidget {
  StatsCounter() : super(key: ArchSampleKeys.statsCounter);

  bool isActive(Todo todo) => !todo.complete;

  bool isCompleted(Todo todo) => todo.complete;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScopedModelDescendant<TodoListModel>(
          builder: (context, child, model) {
        var numCompleted = model.todos.where(isCompleted).toList().length;
        var numActive = model.todos.where(isActive).toList().length;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                ArchSampleLocalizations.of(context).completedTodos,
                style: Theme.of(context).textTheme.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 24.0),
              child: Text(
                '$numCompleted',
                key: ArchSampleKeys.statsNumCompleted,
                style: Theme.of(context).textTheme.subhead,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                ArchSampleLocalizations.of(context).activeTodos,
                style: Theme.of(context).textTheme.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 24.0),
              child: Text(
                '$numActive',
                key: ArchSampleKeys.statsNumActive,
                style: Theme.of(context).textTheme.subhead,
              ),
            )
          ],
        );
      }),
    );
  }
}
