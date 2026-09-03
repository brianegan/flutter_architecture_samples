import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';

import '../todo.dart';

class TodoListView extends StatelessWidget {
  final void Function(BuildContext context, Todo todo) onRemove;
  final void Function(String id, bool complete) onTodoCompleteChanged;
  final ValueChanged<Todo> onTodoSelected;
  final List<Todo> todos;

  const TodoListView({
    super.key,
    required this.onRemove,
    required this.onTodoCompleteChanged,
    required this.onTodoSelected,
    required this.todos,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: ArchSampleKeys.todoList,
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Dismissible(
          key: ArchSampleKeys.todoItem(todo.id),
          onDismissed: (_) => onRemove(context, todo),
          child: ListTile(
            onTap: () => onTodoSelected(todo),
            leading: Checkbox(
              key: ArchSampleKeys.todoItemCheckbox(todo.id),
              value: todo.complete,
              onChanged: (complete) {
                onTodoCompleteChanged(todo.id, complete ?? false);
              },
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
      },
    );
  }
}
