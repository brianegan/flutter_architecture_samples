// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:states_rebuilder_sample/domain/entities/todo.dart';
import 'package:states_rebuilder_sample/service/todos_state.dart';
import 'package:states_rebuilder_sample/ui/exceptions/error_handler.dart';
import 'package:states_rebuilder_sample/ui/pages/detail_screen/detail_screen.dart';
import 'package:todos_app_core/todos_app_core.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  //Accept the todo from the TodoList widget
  TodoItem({
    Key key,
    @required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ArchSampleKeys.todoItem(todo.id),
      onDismissed: (direction) {
        removeTodo(context, todo);
      },
      child: ListTile(
        onTap: () async {
          final shouldDelete = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) {
                return DetailScreen(todo);
              },
            ),
          );
          if (shouldDelete == true) {
            removeTodo(context, todo);
          }
        },
        leading: Checkbox(
          key: ArchSampleKeys.todoItemCheckbox(todo.id),
          value: todo.complete,
          onChanged: (value) {
            final newTodo = todo.copyWith(
              complete: value,
            );
            //Here we get the global ReactiveModel, and use the stream method to call the updateTodo.
            //states_rebuilder will subscribe to this stream and notify observer widgets to rebuild when data is emitted.
            RM.get<TodosState>().setState(
                  (t) => TodosState.updateTodo(t, newTodo),
                  //on Error we want to display a snackbar
                  onError: ErrorHandler.showErrorSnackBar,
                );
          },
        ),
        title: Text(
          todo.task,
          key: ArchSampleKeys.todoItemTask(todo.id),
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(
          todo.note,
          key: ArchSampleKeys.todoItemNote(todo.id),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.subhead,
        ),
      ),
    );
  }

  void removeTodo(BuildContext context, Todo todo) {
    //get the global ReactiveModel, because we want to update the view of the list after removing a todo
    final todosStateRM = RM.get<TodosState>();

    todosStateRM.setState(
      (t) => TodosState.deleteTodo(t, todo),
      onError: ErrorHandler.showErrorSnackBar,
    );

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
          label: ArchSampleLocalizations.of(context).undo,
          onPressed: () {
            //another nested call of stream method to voluntary add the todo back
            todosStateRM.setState(
              (t) => TodosState.addTodo(t, todo),
              onError: ErrorHandler.showErrorSnackBar,
            );
          },
        ),
      ),
    );
  }
}
