import 'package:blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';

class StatsCounter extends StatefulWidget {
  final StatsBloc Function() buildBloc;

  const StatsCounter({
    super.key = ArchSampleKeys.statsCounter,
    required this.buildBloc,
  });

  @override
  StatsCounterState createState() {
    return StatsCounterState();
  }
}

class StatsCounterState extends State<StatsCounter> {
  late StatsBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = widget.buildBloc();
  }

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
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 24.0),
            child: StreamBuilder<int>(
              stream: bloc.numComplete,
              builder: (context, snapshot) => Text(
                '${snapshot.data ?? 0}',
                key: ArchSampleKeys.statsNumCompleted,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              ArchSampleLocalizations.of(context).activeTodos,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 24.0),
            child: StreamBuilder<int>(
              stream: bloc.numActive,
              builder: (context, snapshot) {
                return Text(
                  '${snapshot.data ?? 0}',
                  key: ArchSampleKeys.statsNumActive,
                  style: Theme.of(context).textTheme.titleMedium,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
