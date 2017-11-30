import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scoped_model_sample/models.dart';
import 'package:scoped_model_sample/screens/detail_screen.dart';
import 'package:scoped_model_sample/todo_list_model.dart';
import 'package:scoped_model_sample/widgets/todo_item.dart';

class TodoList extends StatelessWidget {
  TodoList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<TodoListModel>(
      builder: (context, child, model) {
        return new Container(
          child: model.isLoading ? _buildLoading : _buildList(model),
        );
      },
    );
  }

  Center get _buildLoading {
    return new Center(
      child: new CircularProgressIndicator(
        key: ArchSampleKeys.todosLoading,
      ),
    );
  }

  ListView _buildList(TodoListModel model) {
    final todos = model.filteredTodos;

    return new ListView.builder(
      key: ArchSampleKeys.todoList,
      itemCount: todos.length,
      itemBuilder: (BuildContext context, int index) {
        final todo = todos[index];

        return new TodoItem(
          todo: todo,
          onDismissed: (direction) {
            _removeTodo(context, todo);
          },
          onTap: () {
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (_) {
                  return new DetailScreen(
                    todoId: todo.id,
                  );
                },
              ),
            ).then((todo) {
              if (todo is Todo) {
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
    Scaffold.of(context).showSnackBar(
          new SnackBar(
            key: ArchSampleKeys.snackbar,
            duration: new Duration(seconds: 2),
            backgroundColor: Theme.of(context).backgroundColor,
            content: new Text(
              ArchSampleLocalizations.of(context).todoDeleted(todo.task),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            action: new SnackBarAction(
              label: ArchSampleLocalizations.of(context).undo,
              onPressed: () {
                TodoListModel.of(context).addTodo(todo);
              },
            ),
          ),
        );
  }
}
