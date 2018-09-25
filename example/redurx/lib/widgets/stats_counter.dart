import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:redurx_sample/models/app_state.dart';

class StatsCounter extends StatelessWidget {
  StatsCounter() : super(key: ArchSampleKeys.statsCounter);

  @override
  Widget build(BuildContext context) {
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
            child: Connect<AppState, String>(
              convert: (state) => state.numCompletedSelector.toString(),
              where: (prev, next) => next != prev,
              builder: (numCompleted) {
                return Text(
                  '$numCompleted',
                  key: ArchSampleKeys.statsNumCompleted,
                  style: Theme.of(context).textTheme.subhead,
                );
              },
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
            child: Connect<AppState, String>(
              convert: (state) => state.numActiveSelector.toString(),
              where: (prev, next) => next != prev,
              builder: (numActive) {
                return Text(
                  "$numActive",
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
