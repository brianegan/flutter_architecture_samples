// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:bloc_flutter_sample/dependency_injection.dart';
import 'package:bloc_flutter_sample/screens/add_edit_screen.dart';
import 'package:bloc_flutter_sample/widgets/loading.dart';
import 'package:blocs/blocs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';

class DetailScreen extends StatefulWidget {
  final String todoId;

  DetailScreen({
    @required this.todoId,
  }) : super(key: ArchSampleKeys.todoDetailsScreen);

  @override
  DetailScreenState createState() {
    return new DetailScreenState();
  }
}

class DetailScreenState extends State<DetailScreen> {
  TodoBloc todoBloc;

  @override
  void initState() {
    super.initState();
    todoBloc = new TodoBloc(injector.repository);
  }

  @override
  void dispose() {
    todoBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<Todo>(
      stream: todoBloc.todo(widget.todoId).where((todo) => todo != null),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return new LoadingSpinner();

        final todo = snapshot.data;

        return new Scaffold(
          appBar: new AppBar(
            title: new Text(ArchSampleLocalizations.of(context).todoDetails),
            actions: [
              new IconButton(
                key: ArchSampleKeys.deleteTodoButton,
                tooltip: ArchSampleLocalizations.of(context).deleteTodo,
                icon: new Icon(Icons.delete),
                onPressed: () {
                  todoBloc.deleteTodo.add(todo.id);
                  Navigator.pop(context, todo);
                },
              )
            ],
          ),
          body: new Padding(
            padding: new EdgeInsets.all(16.0),
            child: new ListView(
              children: [
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    new Padding(
                      padding: new EdgeInsets.only(right: 8.0),
                      child: new Checkbox(
                        value: todo.complete,
                        key: ArchSampleKeys.detailsTodoItemCheckbox,
                        onChanged: (complete) {
                          todoBloc.updateTodo
                              .add(todo.copyWith(complete: !todo.complete));
                        },
                      ),
                    ),
                    new Expanded(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          new Padding(
                            padding: new EdgeInsets.only(
                              top: 8.0,
                              bottom: 16.0,
                            ),
                            child: new Text(
                              todo.task,
                              key: ArchSampleKeys.detailsTodoItemTask,
                              style: Theme.of(context).textTheme.headline,
                            ),
                          ),
                          new Text(
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
          floatingActionButton: new FloatingActionButton(
            tooltip: ArchSampleLocalizations.of(context).editTodo,
            child: new Icon(Icons.edit),
            key: ArchSampleKeys.editTodoFab,
            onPressed: () {
              Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (context) {
                    return new AddEditScreen(
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
