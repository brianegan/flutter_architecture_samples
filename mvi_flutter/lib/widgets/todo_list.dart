// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:mvi_base/mvi_base.dart';
import 'package:mvi_flutter_sample/screens/detail_screen.dart';
import 'package:mvi_flutter_sample/widgets/loading.dart';
import 'package:mvi_flutter_sample/widgets/todo_item.dart';

class TodoList extends StatelessWidget {
  final bool loading;
  final List<Todo> todos;
  final Function(Todo) updateTodo;
  final Function(String) deleteTodo;
  final Function(Todo) addTodo;

  TodoList({
    Key key,
    @required this.loading,
    @required this.todos,
    @required this.addTodo,
    @required this.deleteTodo,
    @required this.updateTodo,
  }) : super(key: key);

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
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) {
                  return DetailScreen(todoId: todo.id);
                },
              ),
            ).then((todo) {
              if (todo is Todo) {
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
          addTodo(todo);
        },
      ),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }
}
