// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'package:states_rebuilder_sample/domain/entities/todo.dart';
import 'package:states_rebuilder_sample/service/todos_service.dart';
import 'package:states_rebuilder_sample/ui/exceptions/error_handler.dart';
import 'package:states_rebuilder_sample/ui/pages/detail_screen/detail_screen.dart';
import 'package:states_rebuilder_sample/ui/pages/shared_widgets/check_favorite_box.dart';
import 'package:todos_app_core/todos_app_core.dart';

class TodoItem extends StatelessWidget {
  final ReactiveModel<Todo> todoRM;
  Todo get todo => todoRM.value;
  //Accept the todo ReactiveModel from the TodoList widget
  TodoItem({
    Key key,
    @required this.todoRM,
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
                return DetailScreen(todoRM);
              },
            ),
          );
          if (shouldDelete == true) {
            removeTodo(context, todo);
          }
        },
        //Because checkbox for favorite is use here and in the detailed screen, and the both share the same logic,
        //we isolate the widget in a dedicated widget in the shared_widgets folder
        leading: CheckFavoriteBox(
          todoRM: todoRM,
          key: ArchSampleKeys.todoItemCheckbox(todo.id),
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
    final todosServiceRM = RM.get<TodosService>();
    todosServiceRM.setState(
      (s) => s.deleteTodo(todo),
      //another watch, there are tow watch in states_rebuild:
      // 1- This one, in setState, the notification will not be sent unless the watched parameters changes
      // 2- The watch in StateBuilder which is more local, it prevent the watch StateBuilder from rebuilding
      //  even after a ReactiveModel sends a notification
      watch: (todosService) => [todosService.todos.length],
      //Handling the error.
      //Error handling is centralized id the ErrorHandler class
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
            //another nested setState to voluntary add the todo back
            todosServiceRM.setState((s) => s.addTodo(todo));
          },
        ),
      ),
    );
  }
}
