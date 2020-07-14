// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:wire/wire.dart';
import 'package:wire_flutter/wire_flutter.dart';
import 'package:wire_flutter_todo/const/TodoDataParams.dart';

class StatsCounter extends StatelessWidget {
  StatsCounter() : super(key: ArchSampleKeys.statsCounter);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: WireDataBuilder<int>(
        param: TodoDataParams.COUNT,
        builder: (context, notCompletedCount) {
          var allTodoCount = Wire.data(TodoDataParams.LIST).value.length;
          var numCompleted = allTodoCount - notCompletedCount;
          return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                ArchSampleLocalizations.of(context).completedTodos,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 24.0),
              child: Text('$numCompleted',
                key: ArchSampleKeys.statsNumCompleted,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                ArchSampleLocalizations.of(context).activeTodos,
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 24.0),
              child: Text(
                '$notCompletedCount',
                key: ArchSampleKeys.statsNumActive,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            )
          ],
        );},
      ),
    );
  }
}
