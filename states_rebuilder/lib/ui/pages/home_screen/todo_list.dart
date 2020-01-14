// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:states_rebuilder_sample/service/todos_service.dart';
import 'package:states_rebuilder_sample/ui/exceptions/error_handler.dart';
import 'package:todos_app_core/todos_app_core.dart';

import 'todo_item.dart';

class TodoList extends StatelessWidget {
  TodoList() : super(key: ArchSampleKeys.todoList);
  final todosServiceRM = Injector.getAsReactive<TodosService>();
  @override
  Widget build(BuildContext context) {
    //use whenConnectionState method to go through all the possible status of the ReactiveModel
    return todosServiceRM.whenConnectionState(
      onIdle: () => Container(),
      onWaiting: () => Center(
        child: CircularProgressIndicator(
          key: ArchSampleKeys.todosLoading,
        ),
      ),
      onData: (todosService) {
        return ListView.builder(
          key: ArchSampleKeys.todoList,
          itemCount: todosService.todos.length,
          itemBuilder: (BuildContext context, int index) {
            final todo = todosService.todos[index];
            return TodoItem(todo: todo);
          },
        );
      },
      onError: (error) {
        //Delegate error handling to the static method ErrorHandler.getErrorMessage
        return Center(child: Text(ErrorHandler.getErrorMessage(error)));
      },
    );
  }
}
