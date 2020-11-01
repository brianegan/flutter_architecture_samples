// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:rvms_model_sample/display_todos/_manager/todo_manager_.dart';
import 'package:rvms_model_sample/display_todos/_model/todo.dart';
import 'package:rvms_model_sample/display_todos/detail_screen.dart';
import 'package:rvms_model_sample/display_todos/widgets/todo_item.dart';
import 'package:todos_app_core/todos_app_core.dart';

class TodoList extends StatelessWidget with GetItMixin {
  TodoList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todos = watchX((TodoManager x) => x.filteredTodos);

    return ListView.builder(
      key: ArchSampleKeys.todoList,
      itemCount: todos.length,
      itemBuilder: (BuildContext context, int index) {
        final todo = todos[index];

        return TodoItem(
          todo: todo,
          onDismissed: (_) {
            _removeTodo(context, todo);
          },
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) {
                  return DetailScreen(
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
            get<TodoManager>().updateTodo(toggled);
          },
        );
      },
    );
  }

  void _removeTodo(BuildContext context, Todo todo) {
    get<TodoManager>().removeTodo(todo);

    _showUndoSnackbar(context, todo);
  }

  void _showUndoSnackbar(BuildContext context, Todo todo) {
    Scaffold.of(context).showSnackBar(
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
            get<TodoManager>().addTodo(todo);
          },
        ),
      ),
    );
  }
}
