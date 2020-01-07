// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:mvi_base/mvi_base.dart';
import 'package:mvi_flutter_sample/dependency_injection.dart';

class StatsCounter extends StatefulWidget {
  final MviPresenter<StatsModel> Function() initPresenter;

  StatsCounter({Key key, this.initPresenter})
      : super(key: key ?? ArchSampleKeys.statsCounter);

  @override
  StatsCounterState createState() {
    return StatsCounterState();
  }
}

class StatsCounterState extends State<StatsCounter> {
  StatsPresenter presenter;

  @override
  void didChangeDependencies() {
    presenter = widget.initPresenter != null
        ? widget.initPresenter()
        : StatsPresenter(Injector.of(context).todosInteractor);

    presenter.setUp();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    presenter.tearDown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StatsModel>(
      stream: presenter,
      initialData: presenter.latest,
      builder: (context, snapshot) {
        return Center(
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
                  '${snapshot.data?.numComplete ?? 0}',
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
                  '${snapshot.data?.numActive ?? 0}',
                  key: ArchSampleKeys.statsNumActive,
                  style: Theme.of(context).textTheme.subhead,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
