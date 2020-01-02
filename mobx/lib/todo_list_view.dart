import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_sample/store/todo.dart';
import 'package:mobx_sample/store/todo_manager_store.dart';
import 'package:mobx_sample/todo_details_page.dart';
import 'package:provider/provider.dart';

class TodoListView extends StatelessWidget {
  final void Function(BuildContext context, Todo todo) onRemove;

  TodoListView({@required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final todoList = Provider.of<TodoManagerStore>(context);
        final todos = todoList.visibleTodos;

        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (_, index) {
            final todo = todos[index];

            return Observer(
              builder: (context) => Dismissible(
                key: Key(todo.id),
                direction: DismissDirection.horizontal,
                onDismissed: (direction) {
                  if (direction == DismissDirection.startToEnd ||
                      direction == DismissDirection.endToStart) {
                    onRemove(context, todo);
                  }
                },
                child: ListTile(
                  title: Text(
                    todo.title,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                  subtitle: todo.hasNotes
                      ? Text(
                          todo.notes,
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                        )
                      : null,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => TodoDetailsPage(
                                  todo: todo,
                                  onRemove: () {
                                    Navigator.pop(context);
                                    onRemove(context, todo);
                                  },
                                )));
                  },
                  leading: Checkbox(
                    value: todo.done,
                    onChanged: (value) => todo.done = value,
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
