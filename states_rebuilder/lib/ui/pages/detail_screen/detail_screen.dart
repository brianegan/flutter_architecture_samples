// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:states_rebuilder_sample/domain/entities/todo.dart';
import 'package:states_rebuilder_sample/service/todos_state.dart';
import 'package:states_rebuilder_sample/ui/exceptions/error_handler.dart';
import 'package:states_rebuilder_sample/ui/pages/add_edit_screen.dart/add_edit_screen.dart';
import 'package:todos_app_core/todos_app_core.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen(this.todo) : super(key: ArchSampleKeys.todoDetailsScreen);
  final Todo todo;
  final todoRMKey = RMKey<Todo>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ArchSampleLocalizations.of(context).todoDetails),
        actions: [
          IconButton(
            key: ArchSampleKeys.deleteTodoButton,
            tooltip: ArchSampleLocalizations.of(context).deleteTodo,
            icon: Icon(Icons.delete),
            onPressed: () {
              Navigator.pop(context, true);
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            StateBuilder<Todo>(
                //create a local ReactiveModel for the todo
                observe: () => RM.create(todo),
                //associate ti with todoRMKey
                rmKey: todoRMKey,
                builder: (context, todosStateRM) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Checkbox(
                            key: ArchSampleKeys.detailsTodoItemCheckbox,
                            value: todosStateRM.value.complete,
                            onChanged: (value) {
                              final newTodo = todosStateRM.value.copyWith(
                                complete: value,
                              );
                              _updateTodo(context, newTodo);
                            },
                          )),
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
                                todosStateRM.value.task,
                                key: ArchSampleKeys.detailsTodoItemTask,
                                style: Theme.of(context).textTheme.headline,
                              ),
                            ),
                            Text(
                              todosStateRM.value.note,
                              key: ArchSampleKeys.detailsTodoItemNote,
                              style: Theme.of(context).textTheme.subhead,
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            tooltip: ArchSampleLocalizations.of(context).editTodo,
            child: Icon(Icons.edit),
            key: ArchSampleKeys.editTodoFab,
            onPressed: () async {
              final newTodo = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return AddEditPage(
                      key: ArchSampleKeys.editTodoScreen,
                      todo: todoRMKey.value,
                    );
                  },
                ),
              );
              if (newTodo == null) {
                return;
              }
              _updateTodo(context, newTodo);
            },
          );
        },
      ),
    );
  }

  void _updateTodo(BuildContext context, Todo newTodo) {
    final oldTodo = todoRMKey.value;
    todoRMKey.value = newTodo;
    RM
        .get<TodosState>()
        .stream((t) => TodosState.updateTodo(t, newTodo))
        .onError((ctx, error) {
      todoRMKey.value = oldTodo;
      ErrorHandler.showErrorSnackBar(context, error);
    });
  }
}
