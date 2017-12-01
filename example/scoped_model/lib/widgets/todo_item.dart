import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scoped_model_sample/models.dart';

class TodoItem extends StatelessWidget {
  final DismissDirectionCallback onDismissed;
  final GestureTapCallback onTap;
  final ValueChanged<bool> onCheckboxChanged;

  TodoItem({
    @required this.onDismissed,
    @required this.onTap,
    @required this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<TodoModel>(
      builder: (context, child, todo) {
        return new Dismissible(
          key: ArchSampleKeys.todoItem(todo.id),
          onDismissed: onDismissed,
          child: new ListTile(
            onTap: onTap,
            leading: new Checkbox(
              key: ArchSampleKeys.todoItemCheckbox(todo.id),
              value: todo.complete,
              onChanged: onCheckboxChanged,
            ),
            title: new Text(
              todo.task,
              key: ArchSampleKeys.todoItemTask(todo.id),
              style: Theme.of(context).textTheme.title,
            ),
            subtitle: new Text(
              todo.note,
              key: ArchSampleKeys.todoItemNote(todo.id),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
        );
      },
    );
  }
}
