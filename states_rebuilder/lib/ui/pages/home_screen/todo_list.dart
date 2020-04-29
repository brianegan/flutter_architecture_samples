// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:todos_app_core/todos_app_core.dart';

import '../../../service/todos_state.dart';
import 'todo_item.dart';

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateBuilder<TodosState>(
      //As this is the main list of todos, and this list can be update from
      //many widgets and screens (FilterButton, ExtraActionsButton, AddEditScreen, ..)
      //We register this widget with the global injected ReactiveModel.
      //Anywhere in the widget tree if setValue of todosStore is called this StatesRebuild
      // will rebuild
      //In states_rebuild global ReactiveModel is the model that can be invoked all across the widget tree
      //and local ReactiveModel is a model that is meant to be called only locally in the widget where it is created
      observe: () => RM.get<TodosState>(),

      builder: (context, todosStoreRM) {
        //The builder exposes the BuildContext and the ReactiveModel of todosStore
        final todos = todosStoreRM.value.todos;
        return ListView.builder(
          key: ArchSampleKeys.todoList,
          itemCount: todos.length,
          itemBuilder: (BuildContext context, int index) {
            final todo = todos[index];
            return TodoItem(todo: todo);
          },
        );
      },
    );
  }
}
