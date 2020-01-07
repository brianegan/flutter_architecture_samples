import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_sample/models/todo.dart';
import 'package:todos_app_core/todos_app_core.dart';

import 'edit_todo_screen.dart';

class DetailsScreen extends StatelessWidget {
  final Todo todo;
  final void Function() onRemove;

  const DetailsScreen({@required this.todo, @required this.onRemove})
      : super(key: ArchSampleKeys.todoDetailsScreen);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ArchSampleLocalizations.of(context).todoDetails),
        actions: <Widget>[
          IconButton(
            key: ArchSampleKeys.deleteTodoButton,
            tooltip: ArchSampleLocalizations.of(context).deleteTodo,
            icon: const Icon(Icons.delete),
            onPressed: onRemove,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: ArchSampleKeys.editTodoFab,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditTodoScreen(
                todo: todo,
                onEdit: () => Navigator.pop(context),
              ),
            ),
          );
        },
        child: const Icon(Icons.edit),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Observer(
                    builder: (_) => Checkbox(
                      key: ArchSampleKeys.detailsTodoItemCheckbox,
                      value: todo.complete,
                      onChanged: (done) => todo.complete = done,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          bottom: 16.0,
                        ),
                        child: Observer(
                          builder: (context) => Text(
                            todo.task,
                            key: ArchSampleKeys.detailsTodoItemTask,
                            style: Theme.of(context).textTheme.headline,
                          ),
                        ),
                      ),
                      Observer(
                        builder: (_) => Text(
                          todo.note,
                          key: ArchSampleKeys.detailsTodoItemNote,
                          style: Theme.of(context).textTheme.subhead,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
