// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:binder/binder.dart';
import 'package:binder_sample/extensions.dart';
import 'package:binder_sample/logics/todos.dart';
import 'package:binder_sample/models.dart';
import 'package:binder_sample/screens/detail_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';

final todoItemRef = StateRef<Todo>(null);

class TodoItem extends StatelessWidget {
  const TodoItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todo = context.watch(todoItemRef);
    return Dismissible(
      key: ArchSampleKeys.todoItem(todo.id),
      onDismissed: (_) {
        context.use(todosLogicRef).delete(todo);
        ScaffoldMessenger.of(context).showDeleteTodoSnackBar(todo);
      },
      child: ListTile(
        onTap: () async {
          final removedTodo = await Navigator.of(context).push<Todo>(
            MaterialPageRoute(builder: (_) => DetailScreen(id: todo.id)),
          );
          if (removedTodo != null) {
            ScaffoldMessenger.of(context).showDeleteTodoSnackBar(todo);
          }
        },
        leading: Checkbox(
          key: ArchSampleKeys.todoItemCheckbox(todo.id),
          value: todo.complete,
          onChanged: (complete) => context
              .use(todosLogicRef)
              .edit(todo.copyWith(complete: complete)),
        ),
        title: Text(
          todo.task,
          key: ArchSampleKeys.todoItemTask(todo.id),
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: todo.note.isNotEmpty
            ? Text(
                todo.note,
                key: ArchSampleKeys.todoItemNote(todo.id),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle1,
              )
            : null,
      ),
    );
  }
}
