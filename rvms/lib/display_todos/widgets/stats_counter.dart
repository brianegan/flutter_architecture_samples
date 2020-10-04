// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:rvms_model_sample/display_todos/_manager/todo_manager_.dart';
import 'package:rvms_model_sample/display_todos/_model/todo.dart';
import 'package:todos_app_core/todos_app_core.dart';

class StatsCounter extends StatelessWidget with GetItMixin {
  StatsCounter() : super(key: ArchSampleKeys.statsCounter);

  bool isActive(Todo todo) => !todo.complete;

  bool isCompleted(Todo todo) => todo.complete;

  @override
  Widget build(BuildContext context) {
    final todos = watchX((TodoManager x) => x.allTodos);

    var numCompleted = todos.where(isCompleted).toList().length;
    var numActive = todos.where(isActive).toList().length;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              ArchSampleLocalizations.of(context).completedTodos,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 24.0),
            child: Text(
              '$numCompleted',
              key: ArchSampleKeys.statsNumCompleted,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(ArchSampleLocalizations.of(context).activeTodos,
                style: Theme.of(context).textTheme.headline6),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 24.0),
            child: Text(
              "$numActive",
              key: ArchSampleKeys.statsNumActive,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          )
        ],
      ),
    );
  }
}
