// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:redux_sample/containers/edit_todo.dart';
import 'package:redux_sample/models/models.dart';

class DetailsScreen extends StatelessWidget {
  final Todo todo;
  final Function onDelete;
  final Function(bool) toggleCompleted;

  DetailsScreen({
    Key key,
    @required this.todo,
    @required this.onDelete,
    @required this.toggleCompleted,
  }) : super(key: key ?? ArchSampleKeys.todoDetailsScreen);

  @override
  Widget build(BuildContext context) {
    final localizations = ArchSampleLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.todoDetails),
        actions: [
          IconButton(
            tooltip: localizations.deleteTodo,
            key: ArchSampleKeys.deleteTodoButton,
            icon: Icon(Icons.delete),
            onPressed: () {
              onDelete();
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
                    value: todo.complete,
                    onChanged: toggleCompleted,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: '${todo.id}__heroTag',
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(
                            top: 8.0,
                            bottom: 16.0,
                          ),
                          child: Text(
                            todo.task,
                            key: ArchSampleKeys.detailsTodoItemTask,
                            style: Theme.of(context).textTheme.headline,
                          ),
                        ),
                      ),
                      Text(
                        todo.note,
                        key: ArchSampleKeys.detailsTodoItemNote,
                        style: Theme.of(context).textTheme.subhead,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: ArchSampleKeys.editTodoFab,
        tooltip: localizations.editTodo,
        child: Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return EditTodo(
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
