// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:mvc/src/screens/detail_screen.dart';
import 'package:mvc/src/widgets/todo_item.dart';

import 'package:mvc/src/Controller.dart';

class TodoList extends StatelessWidget {
  TodoList({Key key}) : super(key: key);

  static final _con = Con.con;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Con.isLoading ? _buildLoading : _buildList(),
    );
  }

  Center get _buildLoading {
    return Center(
      child: CircularProgressIndicator(
        key: ArchSampleKeys.todosLoading,
      ),
    );
  }

  ListView _buildList() {
    final todos = Con.filteredTodos;
    return ListView.builder(
      key: ArchSampleKeys.todoList,
      itemCount: todos.length,
      itemBuilder: (BuildContext context, int index) {
        final Map todo = todos.elementAt(index).cast<String, Object>();
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
                    todoId: todo['id'],
                  );
                },
              ),
            ).then((todo) {
              if (todo is Map && todo.isNotEmpty) {
                _showUndoSnackbar(context, todo);
              }
            });
          },
          onCheckboxChanged: (complete) {
            _con.checked(todo);
          },
        );
      },
    );
  }

  void _removeTodo(BuildContext context, Map todo) {
    _con.remove(todo);
    _showUndoSnackbar(context, todo);
  }

  void _showUndoSnackbar(BuildContext context, Map todo) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        key: ArchSampleKeys.snackbar,
        duration: Duration(seconds: 2),
        content: Text(
          ArchSampleLocalizations.of(context).todoDeleted(todo['task']),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        action: SnackBarAction(
          key: ArchSampleKeys.snackbarAction(todo['id']),
          label: ArchSampleLocalizations.of(context).undo,
          onPressed: () {
            _con.undo(todo);
          },
        ),
      ),
    );
  }
}
