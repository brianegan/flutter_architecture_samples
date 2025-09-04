import 'package:flutter/material.dart';
import 'package:mvi_base/mvi_base.dart';
import 'package:todos_app_core/todos_app_core.dart';

class TodoItem extends StatelessWidget {
  final DismissDirectionCallback onDismissed;
  final GestureTapCallback onTap;
  final ValueChanged<bool?> onCheckboxChanged;
  final Todo todo;

  const TodoItem({
    super.key,
    required this.onDismissed,
    required this.onTap,
    required this.onCheckboxChanged,
    required this.todo,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ArchSampleKeys.todoItem(todo.id),
      onDismissed: onDismissed,
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(
          key: ArchSampleKeys.todoItemCheckbox(todo.id),
          value: todo.complete,
          onChanged: onCheckboxChanged,
        ),
        title: Text(
          todo.task,
          key: ArchSampleKeys.todoItemTask(todo.id),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(
          todo.note,
          key: ArchSampleKeys.todoItemNote(todo.id),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
