// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:binder/binder.dart';
import 'package:binder_sample/logics/todos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';

class StatsCounter extends StatelessWidget {
  const StatsCounter() : super(key: ArchSampleKeys.statsCounter);

  @override
  Widget build(BuildContext context) {
    final numActive = context.watch(
      todosRef.select((todos) => todos.where((todo) => !todo.complete).length),
    );
    final numCompleted = context.watch(
      todosRef.select((todos) => todos.where((todo) => todo.complete).length),
    );

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
            child: Text(
              ArchSampleLocalizations.of(context).activeTodos,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 24.0),
            child: Text(
              '$numActive',
              key: ArchSampleKeys.statsNumActive,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          )
        ],
      ),
    );
  }
}
