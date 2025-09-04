import 'package:flutter/material.dart';
import 'package:redux_sample/containers/app_loading.dart';
import 'package:redux_sample/presentation/loading_indicator.dart';
import 'package:todos_app_core/todos_app_core.dart';

class StatsCounter extends StatelessWidget {
  final int numActive;
  final int numCompleted;

  const StatsCounter({
    super.key,
    required this.numActive,
    required this.numCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return AppLoading(
      builder: (context, loading) {
        return loading
            ? LoadingIndicator(key: Key('__statsLoading__'))
            : _buildStats(context);
      },
    );
  }

  Widget _buildStats(BuildContext context) {
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
            child: Text(
              '$numCompleted',
              key: ArchSampleKeys.statsNumCompleted,
              style: Theme.of(context).textTheme.titleMedium,
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
            child: Text(
              '$numActive',
              key: ArchSampleKeys.statsNumActive,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
