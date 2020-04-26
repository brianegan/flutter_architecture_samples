// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:todos_app_core/todos_app_core.dart';

import '../../../domain/entities/todo.dart';
import '../../../service/todos_service.dart';
import 'todo_item.dart';

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateBuilder<TodosService>(
      //As this is the main list of todos, and this list can be update from
      //many widgets and screens (FilterButton, ExtraActionsButton, AddEditScreen, ..)
      //We register this widget with the global injected ReactiveModel.
      //any where in the widget tree if setState of TodosService is called this StatesRebuild
      // will rebuild
      //In states_rebuild global ReactiveModel is the model that can be invoked all across the widget tree
      //and local ReactiveModel is a model that is meant to be called only locally in the widget where it is created
      observe: () => RM.get<TodosService>(),
      //The watch parameter is used to limit the rebuild of this StateBuilder.
      //Even if TodosService emits a notification this widget will rebuild only if:
      // 1- the length of the todo list is changed (add / remove a todo)
      // 2- the active filter changes (From FilterButton widget)
      // 3- The number of active todos changes (From ExtraActionsButton widget)
      //
      //Notice that if we edit one todo this StateBuilder will not update
      watch: (todosServiceRM) => [
        todosServiceRM.state.todos.length,
        todosServiceRM.state.activeFilter,
        todosServiceRM.state.numActive,
      ],
      builder: (context, todosServiceRM) {
        //The builder exposes the BuildContext and the ReactiveModel of TodosService
        return ListView.builder(
          key: ArchSampleKeys.todoList,
          itemCount: todosServiceRM.state.todos.length,
          itemBuilder: (BuildContext context, int index) {
            final todo = todosServiceRM.state.todos[index];
            //This is important.
            //As we want to limit the rebuild of the listView, we want to rebuild only the listTile
            //of the todo that changed.
            //For this reason, we Wrapped each todo with a StateBuilder and subscribe it to
            //a ReactiveModel model created from the todo
            return StateBuilder<Todo>(
              //Key here is very important because StateBuilder is a StatefulWidget (this is a Flutter concept)
              key: Key(todo.id),
              //here we created a local ReactiveModel from one todo of the list
              observe: () => RM.create(todo),
              //This didUpdateWidget is used because if we mark all complete from the ExtraActionsButton,
              //The listBuilder will update, but the StateBuilder for single todo will still have the old todo.
              //In the didUpdateWidget, we check if the todo is modified, we set it and notify
              //the StateBuilder to change

              didUpdateWidget: (context, todoRM, oldWidget) {
                if (todoRM.value != todo) {
                  print('didUpdateWidget (${todoRM.value} $todo');
                  //set and notify the observer this StateBuilder to rebuild
                  todoRM.value = todo;
                }
              },
              builder: (context, todoRM) {
                print("builder");
                //render TodoItem and pass the local ReactiveModel through the constructor
                return TodoItem(todoRM: todoRM);
              },
            );
          },
        );
      },
    );
  }
}
