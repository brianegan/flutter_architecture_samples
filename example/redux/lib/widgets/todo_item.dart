import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:redux_sample/models.dart';

class TodoItem extends StatelessWidget {
  final DismissDirectionCallback onDismissed;
  final GestureTapCallback onTap;
  final ValueChanged<bool> onCheckboxChanged;
  final Todo todo;

  TodoItem({
    @required this.onDismissed,
    @required this.onTap,
    @required this.onCheckboxChanged,
    @required this.todo,
  });

  @override
  Widget build(BuildContext context) {
    return new Dismissible(
      key: new Key(todo.id),
      onDismissed: onDismissed,
      child: new ListTile(
        onTap: onTap,
        leading: new Checkbox(
          value: todo.complete,
          onChanged: onCheckboxChanged,
        ),
        title: new Text(
          todo.task,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: new Text(
          todo.note,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.subhead,
        ),
      ),
    );
  }
}
