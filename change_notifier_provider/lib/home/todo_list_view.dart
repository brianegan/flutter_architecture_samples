import 'package:change_notifier_provider_sample/todo_list_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_app_core/todos_app_core.dart';

import '../details_screen.dart';
import '../models.dart';

class TodoListView extends StatelessWidget {
  final void Function(BuildContext context, Todo todo) onRemove;

  const TodoListView({super.key, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Selector<TodoListModel, List<Todo>>(
      selector: (_, model) => model.filteredTodos,
      builder: (context, todos, _) {
        return ListView.builder(
          key: ArchSampleKeys.todoList,
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];

            return Dismissible(
              key: ArchSampleKeys.todoItem(todo.id),
              onDismissed: (_) => onRemove(context, todo),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) {
                        return DetailsScreen(
                          id: todo.id,
                          onRemove: () {
                            Navigator.pop(context);
                            onRemove(context, todo);
                          },
                        );
                      },
                    ),
                  );
                },
                leading: Checkbox(
                  key: ArchSampleKeys.todoItemCheckbox(todo.id),
                  value: todo.complete,
                  onChanged: (complete) {
                    Provider.of<TodoListModel>(
                      context,
                      listen: false,
                    ).updateTodo(todo.copy(complete: complete));
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
      },
    );
  }
}
