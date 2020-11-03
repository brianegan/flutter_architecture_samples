// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:binder/binder.dart';
import 'package:binder_sample/extensions.dart';
import 'package:binder_sample/logics/todos.dart';
import 'package:binder_sample/screens/add_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({@required this.id})
      : super(key: ArchSampleKeys.todoDetailsScreen);

  final String id;

  @override
  Widget build(BuildContext context) {
    final todo = context.watch(todosRef.select(
      (todos) => todos.firstWhere((todo) => todo.id == id, orElse: () => null),
    ));

    return Scaffold(
      appBar: AppBar(
        title: Text(ArchSampleLocalizations.of(context).todoDetails),
        actions: [
          IconButton(
            key: ArchSampleKeys.deleteTodoButton,
            tooltip: ArchSampleLocalizations.of(context).deleteTodo,
            icon: Icon(Icons.delete),
            onPressed: () {
              Navigator.pop(context, todo);
              context.use(todosLogicRef).delete(todo);
              ScaffoldMessenger.of(context).showDeleteTodoSnackBar(todo);
            },
          )
        ],
      ),
      body: todo == null
          ? const SizedBox()
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Checkbox(
                          value: todo.complete,
                          key: ArchSampleKeys.detailsTodoItemCheckbox,
                          onChanged: (complete) {
                            context
                                .use(todosLogicRef)
                                .edit(todo.copyWith(complete: complete));
                          },
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: 8.0,
                                bottom: 16.0,
                              ),
                              child: Text(
                                todo.task,
                                key: ArchSampleKeys.detailsTodoItemTask,
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ),
                            Text(
                              todo.note,
                              key: ArchSampleKeys.detailsTodoItemNote,
                              style: Theme.of(context).textTheme.subtitle1,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: ArchSampleLocalizations.of(context).editTodo,
        child: Icon(Icons.edit),
        key: ArchSampleKeys.editTodoFab,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return AddEditScreen(
                  key: ArchSampleKeys.editTodoScreen,
                  todo: todo,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
