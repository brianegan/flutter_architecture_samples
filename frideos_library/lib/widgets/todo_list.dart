import 'package:flutter/material.dart';

import 'package:todos_app_core/todos_app_core.dart';

import 'package:frideos/frideos.dart';

import 'package:frideos_library/app_state.dart';
import 'package:frideos_library/models/todo.dart';
import 'package:frideos_library/screens/detail_screen.dart';
import 'package:frideos_library/widgets/loading.dart';
import 'package:frideos_library/widgets/todo_item.dart';

class TodoList extends StatelessWidget {
  TodoList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = AppStateProvider.of<AppState>(context).todosBloc;

    return ValueBuilder<List<Todo>>(
      streamed: bloc.visibleTodos,
      noDataChild: LoadingSpinner(key: ArchSampleKeys.todosLoading),
      builder: (context, snapshot) => Container(
        child: ListView.builder(
            key: ArchSampleKeys.todoList,
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              final todo = snapshot.data[index];

              return TodoItem(
                todo: todo,
                onDismissed: (direction) {
                  _removeTodo(context, todo);
                },
                onTap: () {
                  bloc.currentTodo.value = todo;

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailScreen()),
                  ).then((todo) {
                    if (todo is Todo) {
                      _showUndoSnackbar(context, todo);
                    }
                  });
                },
                onCheckboxChanged: (complete) => bloc.onCheckboxChanged(todo),
              );
            }),
      ),
    );
  }

  void _removeTodo(BuildContext context, Todo todo) {
    AppStateProvider.of<AppState>(context).todosBloc.deleteTodo(todo);
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
          AppStateProvider.of<AppState>(context).todosBloc.addTodo(todo);
        },
      ),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }
}
