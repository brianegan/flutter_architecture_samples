import 'package:flutter/material.dart';
import 'package:simple_bloc_flutter_sample/screens/detail_screen.dart';
import 'package:simple_bloc_flutter_sample/widgets/loading.dart';
import 'package:simple_bloc_flutter_sample/widgets/todo_item.dart';
import 'package:simple_bloc_flutter_sample/widgets/todos_bloc_provider.dart';
import 'package:simple_blocs/simple_blocs.dart';
import 'package:todos_app_core/todos_app_core.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Todo>>(
      stream: TodosBlocProvider.of(context).visibleTodos,
      builder: (context, snapshot) => snapshot.hasData
          ? _buildList(snapshot.data!)
          : LoadingSpinner(key: ArchSampleKeys.todosLoading),
    );
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
                  MaterialPageRoute<Todo>(
                    builder: (context) => DetailScreen(todoId: todo.id),
                  ),
                )
                .then((todo) {
                  if (todo is Todo) {
                    if (context.mounted) {
                      _showUndoSnackbar(context, todo);
                    }
                  }
                });
          },
          onCheckboxChanged: (complete) {
            TodosBlocProvider.of(
              context,
            ).updateTodo(todo.copyWith(complete: !todo.complete));
          },
        );
      },
    );
  }

  void _removeTodo(BuildContext context, Todo todo) {
    TodosBlocProvider.of(context).deleteTodo(todo.id);

    _showUndoSnackbar(context, todo);
  }

  void _showUndoSnackbar(BuildContext context, Todo todo) {
    final snackBar = SnackBar(
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
          TodosBlocProvider.of(context).addTodo(todo);
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
