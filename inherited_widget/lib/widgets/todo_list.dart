// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:inherited_widget_sample/models.dart';
import 'package:inherited_widget_sample/screens/detail_screen.dart';
import 'package:inherited_widget_sample/state_container.dart';
import 'package:inherited_widget_sample/widgets/todo_item.dart';

class TodoList extends StatelessWidget {
  TodoList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final container = StateContainer.of(context);

    return Container(
      child: container.state.isLoading ? _buildLoading : _buildList(container),
    );
  }

  Center get _buildLoading {
    return Center(
      child: CircularProgressIndicator(
        key: ArchSampleKeys.todosLoading,
      ),
    );
  }

  ListView _buildList(StateContainerState container) {
    final todos = container.state.filteredTodos;

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
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) {
                  return DetailScreen(
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
    StateContainer.of(context).removeTodo(todo);

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
          StateContainer.of(context).addTodo(todo);
        },
      ),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }
}
