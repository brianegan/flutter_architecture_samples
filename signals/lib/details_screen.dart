import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:todos_app_core/todos_app_core.dart';

import 'edit_todo_screen.dart';
import 'todo.dart';

class DetailsScreen extends StatelessWidget {
  final Todo todo;
  final void Function() onRemove;

  const DetailsScreen({required this.todo, required this.onRemove})
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: ArchSampleKeys.editTodoFab,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
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
                  child: Watch(
                    (_) => Checkbox(
                      key: ArchSampleKeys.detailsTodoItemCheckbox,
                      value: todo.complete.value,
                      onChanged: (done) => todo.complete.value = done ?? false,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                        child: Watch(
                          (context) => Text(
                            todo.task.value,
                            key: ArchSampleKeys.detailsTodoItemTask,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      ),
                      Watch(
                        (_) => Text(
                          todo.note.value,
                          key: ArchSampleKeys.detailsTodoItemNote,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
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
