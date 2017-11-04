import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:redux_sample/containers/app_loading.dart';
import 'package:redux_sample/widgets/loading_indicator.dart';

class StatsCounter extends StatelessWidget {
  final int numActive;
  final int numCompleted;

  StatsCounter({
    @required this.numActive,
    @required this.numCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return new AppLoading(builder: (context, loading) {
      return loading
          ? new LoadingIndicator(key: new Key('__statsLoading__'))
          : _buildStats(context);
    });
  }

  Widget _buildStats(BuildContext context) {
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
              key: ArchSampleKeys.statsCompletedItems,
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
              key: ArchSampleKeys.statsActiveItems,
              style: Theme.of(context).textTheme.subhead,
            ),
          )
        ],
      ),
    );
  }
}
