// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart' show required;
import 'package:flutter/material.dart';

import 'package:todos_app_core/todos_app_core.dart'
    show ArchSampleKeys, ArchSampleLocalizations;

import 'package:mvc/src/screens/add_edit_screen.dart' show AddEditScreen;

import 'package:mvc/src/Controller.dart' show Con;

class DetailScreen extends StatelessWidget {
  final String todoId;

  final Con con = Con.con;

  DetailScreen({
    @required this.todoId,
  }) : super(key: ArchSampleKeys.todoDetailsScreen);

  @override
  Widget build(BuildContext context) {
    Map todo = con.todoById(todoId);
    return Scaffold(
      appBar: AppBar(
        title: Text(ArchSampleLocalizations.of(context).todoDetails),
        actions: [
          IconButton(
            key: ArchSampleKeys.deleteTodoButton,
            tooltip: ArchSampleLocalizations.of(context).deleteTodo,
            icon: Icon(Icons.delete),
            onPressed: () {
              con.remove(todo);
              Navigator.pop(context, todo);
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Checkbox(
                    value: todo['complete'],
                    key: ArchSampleKeys.detailsTodoItemCheckbox,
                    onChanged: (complete) {
                      con.checked(todo);
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
                          todo['task'],
                          key: ArchSampleKeys.detailsTodoItemTask,
                          style: Theme.of(context).textTheme.headline,
                        ),
                      ),
                      Text(
                        todo['note'],
                        key: ArchSampleKeys.detailsTodoItemNote,
                        style: Theme.of(context).textTheme.subhead,
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
                  todoId: todoId,
                  key: ArchSampleKeys.editTodoScreen,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
