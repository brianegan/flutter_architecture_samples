import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scoped_model_sample/state_container.dart';
import 'package:scoped_model_sample/models.dart';
import 'package:scoped_model_sample/screens/detail_screen.dart';
import 'package:scoped_model_sample/widgets/todo_item.dart';

class TodoList extends StatelessWidget {
  TodoList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<StateContainer>(
      builder: (context, child, container) {
        return new Container(
          child:
              container.state.isLoading ? _buildLoading : _buildList(container),
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

  ListView _buildList(StateContainer container) {
    final todos = container.state.filteredTodos;

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
                    todo: todo,
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
            container.updateTodo(todo, complete: !todo.complete);
          },
        );
      },
    );
  }

  void _removeTodo(BuildContext context, Todo todo) {
    new ModelFinder<StateContainer>().of(context).removeTodo(todo);

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
                new ModelFinder<StateContainer>().of(context).addTodo(todo);
              },
            ),
          ),
        );
  }
}
