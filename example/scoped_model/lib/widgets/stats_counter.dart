import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scoped_model_sample/models.dart';
import 'package:scoped_model_sample/todo_list_model.dart';

class StatsCounter extends StatelessWidget {
  StatsCounter() : super(key: ArchSampleKeys.statsCounter);

  bool isActive(Todo todo) => !todo.complete;

  bool isCompleted(Todo todo) => todo.complete;

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new ScopedModelDescendant<TodoListModel>(
          builder: (context, child, model) {
        var numCompleted = model.todos.where(isCompleted).toList().length;
        var numActive = model.todos.where(isActive).toList().length;

        return new Column(
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
        );
      }),
    );
  }
}
