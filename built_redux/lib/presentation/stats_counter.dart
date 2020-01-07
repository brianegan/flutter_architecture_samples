// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:built_redux_sample/containers/app_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';

class StatsCounter extends StatelessWidget {
  final int numActive;
  final int numCompleted;

  StatsCounter({
    @required this.numActive,
    @required this.numCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return AppLoading(builder: (context, loading) {
      return loading
          ? Center(
              key: ArchSampleKeys.statsLoading,
              child: CircularProgressIndicator(
                key: ArchSampleKeys.statsLoading,
              ))
          : Center(
              child: Column(
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
              ),
            );
    });
  }
}
