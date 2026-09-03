import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';

class StatsView extends StatelessWidget {
  final int numActive;
  final int numCompleted;

  const StatsView({
    super.key,
    required this.numActive,
    required this.numCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              ArchSampleLocalizations.of(context).completedTodos,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Text(
              '$numCompleted',
              key: ArchSampleKeys.statsNumCompleted,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              ArchSampleLocalizations.of(context).activeTodos,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
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
