import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:todos_app_core/todos_app_core.dart';

import 'package:frideos/frideos.dart';

import 'package:frideos_library/app_state.dart';

class StatsCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = AppStateProvider.of<AppState>(context).statsBloc;

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
            child: ValueBuilder<int>(
              streamed: bloc.numComplete,
              builder: (context, snapshot) => Text(
                '${snapshot.data ?? 0}',
                key: ArchSampleKeys.statsNumCompleted,
                style: Theme.of(context).textTheme.subhead,
              ),
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
            child: ValueBuilder<int>(
              streamed: bloc.numActive,
              builder: (context, snapshot) {
                return Text(
                  '${snapshot.data ?? 0}',
                  key: ArchSampleKeys.statsNumActive,
                  style: Theme.of(context).textTheme.subhead,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
