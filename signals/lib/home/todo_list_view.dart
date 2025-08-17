import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:signals_sample/todo_list_controller.dart';
import 'package:todos_app_core/todos_app_core.dart';

import '../details_screen.dart';
import '../todo.dart';

class TodoListView extends StatelessWidget {
  final void Function(BuildContext context, Todo todo) onRemove;

  const TodoListView({super.key, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final todos = context.read<TodoListController>().visibleTodos;

      return ListView.builder(
        key: ArchSampleKeys.todoList,
        itemCount: todos.value.length,
        itemBuilder: (context, index) {
          final todo = todos.value[index];

          return Dismissible(
            key: ArchSampleKeys.todoItem(todo.id.value),
            onDismissed: (_) => onRemove(context, todo),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) {
                      return DetailsScreen(
                        todo: todo,
                        onRemove: () {
                          Navigator.pop(context);
                          onRemove(context, todo);
                        },
                      );
                    },
                  ),
                );
              },
              leading: Watch(
                (_) => Checkbox(
                  key: ArchSampleKeys.todoItemCheckbox(todo.id.value),
                  value: todo.complete.value,
                  onChanged: (done) => todo.complete.value = done ?? false,
                ),
              ),
              title: Watch(
                (context) => Text(
                  todo.task.value,
                  key: ArchSampleKeys.todoItemTask(todo.id.value),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              subtitle: Watch(
                (_) => Text(
                  todo.note.value,
                  key: ArchSampleKeys.todoItemNote(todo.id.value),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
