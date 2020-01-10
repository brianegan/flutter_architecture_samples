import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:change_notifier_provider_sample/todo_list_model.dart';
import 'package:todos_app_core/todos_app_core.dart';

class StatsView extends StatelessWidget {
  const StatsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              ArchSampleLocalizations.of(context).completedTodos,
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Selector<TodoListModel, int>(
              selector: (_, model) => model.numCompleted,
              builder: (context, numCompleted, _) => Text(
                '$numCompleted',
                key: ArchSampleKeys.statsNumCompleted,
                style: Theme.of(context).textTheme.subhead,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              ArchSampleLocalizations.of(context).activeTodos,
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Selector<TodoListModel, int>(
              selector: (_, model) => model.numActive,
              builder: (context, numActive, _) => Text(
                '$numActive',
                key: ArchSampleKeys.statsNumActive,
                style: Theme.of(context).textTheme.subhead,
              ),
            ),
          )
        ],
      ),
    );
  }
}
