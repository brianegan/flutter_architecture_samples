import 'package:flutter/material.dart';
import 'package:mvi_base/mvi_base.dart';
import 'package:mvi_flutter_sample/screens/detail_screen.dart';
import 'package:mvi_flutter_sample/widgets/loading.dart';
import 'package:mvi_flutter_sample/widgets/todo_item.dart';
import 'package:todos_app_core/todos_app_core.dart';

class TodoList extends StatelessWidget {
  final bool loading;
  final List<Todo> todos;
  final void Function(Todo) updateTodo;
  final void Function(String) deleteTodo;
  final void Function(Todo) addTodo;

  const TodoList({
    super.key,
    required this.loading,
    required this.todos,
    required this.addTodo,
    required this.deleteTodo,
    required this.updateTodo,
  });

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingSpinner(key: ArchSampleKeys.todosLoading)
        : _buildList(todos);
  }

  ListView _buildList(List<Todo> todos) {
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
          onTap: () {
            Navigator.of(context)
                .push(
                  MaterialPageRoute<Todo?>(
                    builder: (_) {
                      return DetailScreen(todoId: todo.id);
                    },
                  ),
                )
                .then((todo) {
                  if (todo is Todo && context.mounted) {
                    _showUndoSnackbar(context, todo);
                  }
                });
          },
          onCheckboxChanged: (complete) {
            updateTodo(todo.copyWith(complete: !todo.complete));
          },
        );
      },
    );
  }

  void _removeTodo(BuildContext context, Todo todo) {
    deleteTodo(todo.id);

    _showUndoSnackbar(context, todo);
  }

  void _showUndoSnackbar(BuildContext context, Todo todo) {
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
          key: ArchSampleKeys.snackbarAction(todo.id),
          label: ArchSampleLocalizations.of(context).undo,
          onPressed: () {
            addTodo(todo);
          },
        ),
      ),
    );
  }
}
