import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_sample/stores/todo_store.dart';
import 'package:provider/provider.dart';
import 'package:todos_app_core/todos_app_core.dart';

class StatsView extends StatelessWidget {
  const StatsView();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<TodoStore>(context);

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
            child: Observer(
              builder: (context) => Text(
                '${store.numCompleted}',
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
            child: Observer(
              builder: (context) => Text(
                '${store.numPending}',
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
