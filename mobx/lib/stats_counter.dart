import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_sample/model/todo_manager_store.dart';
import 'package:provider/provider.dart';

class StatsCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TodoManagerStore todoList = Provider.of<TodoManagerStore>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Complete Todos',
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 24.0),
            child: Observer(
              builder: (context) => Text(
                todoList.completedTodos.length.toString(),
                style: Theme.of(context).textTheme.subhead,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Active Todos',
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 24.0),
            child: Observer(
              builder: (context) => Text(
                todoList.pendingTodos.length.toString(),
                style: Theme.of(context).textTheme.subhead,
              ),
            ),
          )
        ],
      ),
    );
  }
}
