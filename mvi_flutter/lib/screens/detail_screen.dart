// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:mvi_base/mvi_base.dart';
import 'package:mvi_flutter_sample/dependency_injection.dart';
import 'package:mvi_flutter_sample/screens/add_edit_screen.dart';
import 'package:mvi_flutter_sample/widgets/loading.dart';

class DetailScreen extends StatefulWidget {
  final String todoId;
  final MviPresenter<Todo> Function(DetailView) initPresenter;

  DetailScreen({
    Key key,
    @required this.todoId,
    this.initPresenter,
  }) : super(key: key ?? ArchSampleKeys.todoDetailsScreen);

  @override
  DetailScreenState createState() {
    return DetailScreenState();
  }
}

class DetailScreenState extends State<DetailScreen> with DetailView {
  MviPresenter<Todo> presenter;

  @override
  void didChangeDependencies() {
    presenter = widget.initPresenter != null
        ? widget.initPresenter(this)
        : DetailPresenter(
            id: widget.todoId,
            view: this,
            interactor: Injector.of(context).todosInteractor,
          );

    presenter.setUp();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    tearDown();
    presenter.tearDown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Todo>(
      stream: presenter.where((todo) => todo != null),
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
                  deleteTodo.add(todo.id);
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
                          updateTodo
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
                      updateTodo: updateTodo.add,
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
