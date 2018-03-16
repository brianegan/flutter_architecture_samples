// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved. 
// Use of this source code is governed by the MIT license that can be found 
// in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:inherited_widget_sample/state_container.dart';

class StatsCounter extends StatelessWidget {
  StatsCounter() : super(key: ArchSampleKeys.statsCounter);

  @override
  Widget build(BuildContext context) {
    final container = StateContainer.of(context);
    final numCompleted = container.state.numCompleted;
    final numActive = container.state.numActive;

    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Padding(
            padding: new EdgeInsets.only(bottom: 8.0),
            child: new Text(
              ArchSampleLocalizations.of(context).completedTodos,
              style: Theme.of(context).textTheme.title,
            ),
          ),
          new Padding(
            padding: new EdgeInsets.only(bottom: 24.0),
            child: new Text(
              '$numCompleted',
              key: ArchSampleKeys.statsNumCompleted,
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          new Padding(
            padding: new EdgeInsets.only(bottom: 8.0),
            child: new Text(
              ArchSampleLocalizations.of(context).activeTodos,
              style: Theme.of(context).textTheme.title,
            ),
          ),
          new Padding(
            padding: new EdgeInsets.only(bottom: 24.0),
            child: new Text(
              "$numActive",
              key: ArchSampleKeys.statsNumActive,
              style: Theme.of(context).textTheme.subhead,
            ),
          )
        ],
      ),
    );
  }
}
