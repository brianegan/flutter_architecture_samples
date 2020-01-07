import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_sample/models/todo.dart';
import 'package:mobx_sample/stores/todo_store.dart';
import 'package:provider/provider.dart';
import 'package:todos_app_core/todos_app_core.dart';

import '../details_screen.dart';

class TodoListView extends StatelessWidget {
  final void Function(BuildContext context, Todo todo) onRemove;

  TodoListView({Key key, @required this.onRemove}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final todos = Provider.of<TodoStore>(context).visibleTodos;

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
                    MaterialPageRoute(
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
                leading: Observer(
                  builder: (_) => Checkbox(
                    key: ArchSampleKeys.todoItemCheckbox(todo.id),
                    value: todo.complete,
                    onChanged: (done) => todo.complete = done,
                  ),
                ),
                title: Observer(
                  builder: (context) => Text(
                    todo.task,
                    key: ArchSampleKeys.todoItemTask(todo.id),
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
                subtitle: Observer(
                  builder: (_) => Text(
                    todo.note,
                    key: ArchSampleKeys.todoItemNote(todo.id),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
