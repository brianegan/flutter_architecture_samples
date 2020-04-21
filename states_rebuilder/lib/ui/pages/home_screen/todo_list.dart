// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:states_rebuilder_sample/service/todos_service.dart';
import 'package:states_rebuilder_sample/ui/common/enums.dart';
import 'package:todos_app_core/todos_app_core.dart';

import 'todo_item.dart';

class TodoList extends StatelessWidget {
  TodoList();
  @override
  Widget build(BuildContext context) {
    return StateBuilder<TodosService>(
      observe: () => RM.get<TodosService>(),
      tag: AppTab.todos,
      builder: (context, todosServiceRM) {
        print('rebuild of todoList');
        return ListView.builder(
          key: ArchSampleKeys.todoList,
          itemCount: todosServiceRM.state.todos.length,
          itemBuilder: (BuildContext context, int index) {
            final todo = todosServiceRM.state.todos[index];
            return TodoItem(todo: todo);
          },
        );
      },
    );
  }
}
