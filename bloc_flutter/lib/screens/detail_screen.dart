// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:bloc_flutter_sample/screens/add_edit_screen.dart';
import 'package:bloc_flutter_sample/widgets/loading.dart';
import 'package:blocs/blocs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';

class DetailScreen extends StatefulWidget {
  final String todoId;
  final TodoBloc Function() initBloc;

  DetailScreen({
    @required this.todoId,
    @required this.initBloc,
  }) : super(key: ArchSampleKeys.todoDetailsScreen);

  @override
  DetailScreenState createState() {
    return DetailScreenState();
  }
}

class DetailScreenState extends State<DetailScreen> {
  TodoBloc todoBloc;

  @override
  void initState() {
    super.initState();
    todoBloc = widget.initBloc();
  }

  @override
  void dispose() {
    todoBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Todo>(
      stream: todoBloc.todo(widget.todoId).where((todo) => todo != null),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LoadingSpinner();

        final todo = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            title: Text(ArchSampleLocalizations.of(context).todoDetails),
            actions: [
              IconButton(
                key: ArchSampleKeys.deleteTodoButton,
                tooltip: ArchSampleLocalizations.of(context).deleteTodo,
                icon: Icon(Icons.delete),
                onPressed: () {
                  todoBloc.deleteTodo.add(todo.id);
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
                        key: ArchSampleKeys.detailsTodoItemCheckbox,
                        onChanged: (complete) {
                          todoBloc.updateTodo
                              .add(todo.copyWith(complete: !todo.complete));
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
                              style: Theme.of(context).textTheme.headline,
                            ),
                          ),
                          Text(
                            todo.note,
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
                      todo: todo,
                      updateTodo: todoBloc.updateTodo.add,
                      key: ArchSampleKeys.editTodoScreen,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
