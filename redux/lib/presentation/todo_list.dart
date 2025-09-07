import 'package:flutter/material.dart';
import 'package:redux_sample/containers/app_loading.dart';
import 'package:redux_sample/containers/todo_details.dart';
import 'package:redux_sample/models/models.dart';
import 'package:redux_sample/presentation/loading_indicator.dart';
import 'package:redux_sample/presentation/todo_item.dart';
import 'package:todos_app_core/todos_app_core.dart';

class TodoList extends StatelessWidget {
  final List<Todo> todos;
  final void Function(Todo, bool?) onCheckboxChanged;
  final void Function(Todo) onRemove;
  final void Function(Todo) onUndoRemove;

  const TodoList({
    super.key,
    required this.todos,
    required this.onCheckboxChanged,
    required this.onRemove,
    required this.onUndoRemove,
  });

  @override
  Widget build(BuildContext context) {
    return AppLoading(
      builder: (context, loading) {
        return loading ? LoadingIndicator() : _buildListView();
      },
    );
  }

  ListView _buildListView() {
    return ListView.builder(
      key: ArchSampleKeys.todoList,
      itemCount: todos.length,
      itemBuilder: (BuildContext context, int index) {
        final todo = todos[index];

        return TodoItem(
          todo: todo,
          onDismissed: (direction) {
            _removeTodo(context, todo);
          },
          onTap: () => _onTodoTap(context, todo),
          onCheckboxChanged: (complete) {
            onCheckboxChanged(todo, complete);
          },
        );
      },
    );
  }

  void _removeTodo(BuildContext context, Todo todo) {
    onRemove(todo);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          ArchSampleLocalizations.of(context).todoDeleted(todo.task),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        action: SnackBarAction(
          label: ArchSampleLocalizations.of(context).undo,
          onPressed: () => onUndoRemove(todo),
        ),
      ),
    );
  }

  void _onTodoTap(BuildContext context, Todo todo) {
    Navigator.of(context)
        .push(MaterialPageRoute<Todo>(builder: (_) => TodoDetails(id: todo.id)))
        .then((removedTodo) {
          if (removedTodo != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                key: ArchSampleKeys.snackbar,
                duration: Duration(seconds: 2),
                content: Text(
                  ArchSampleLocalizations.of(context).todoDeleted(todo.task),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                action: SnackBarAction(
                  label: ArchSampleLocalizations.of(context).undo,
                  onPressed: () {
                    onUndoRemove(todo);
                  },
                ),
              ),
            );
          }
        });
  }
}
