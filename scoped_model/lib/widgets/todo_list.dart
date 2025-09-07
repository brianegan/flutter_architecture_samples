import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scoped_model_sample/models.dart';
import 'package:scoped_model_sample/screens/detail_screen.dart';
import 'package:scoped_model_sample/todo_list_model.dart';
import 'package:scoped_model_sample/widgets/todo_item.dart';
import 'package:todos_app_core/todos_app_core.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TodoListModel>(
      builder: (context, child, model) {
        return Container(
          child: model.isLoading ? _buildLoading : _buildList(model),
        );
      },
    );
  }

  Center get _buildLoading {
    return Center(
      child: CircularProgressIndicator(key: ArchSampleKeys.todosLoading),
    );
  }

  ListView _buildList(TodoListModel model) {
    final todos = model.filteredTodos;

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
            var toggled = todo.copy(complete: !todo.complete);
            model.updateTodo(toggled);
          },
        );
      },
    );
  }

  void _removeTodo(BuildContext context, Todo todo) {
    TodoListModel.of(context).removeTodo(todo);

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
            TodoListModel.of(context).addTodo(todo);
          },
        ),
      ),
    );
  }
}
