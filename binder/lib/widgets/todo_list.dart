// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:binder/binder.dart';
import 'package:binder_sample/logics/home_screen.dart';
import 'package:binder_sample/logics/todos.dart';
import 'package:binder_sample/models.dart';
import 'package:binder_sample/widgets/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';

final filteredTodosRef = Computed((watch) {
  final filter = watch(activeFilterRef);
  return watch(todosRef).where((todo) {
    switch (filter) {
      case VisibilityFilter.active:
        return !todo.complete;
      case VisibilityFilter.completed:
        return todo.complete;
      default:
        return true;
    }
  }).toList();
});

class TodoList extends StatelessWidget {
  const TodoList() : super(key: ArchSampleKeys.todoList);

  @override
  Widget build(BuildContext context) {
    final loading = !context.watch(isLoadedRef);
    final filteredTodos = context.watch(filteredTodosRef);

    return Container(
      child: loading
          ? Center(
              child: CircularProgressIndicator(
              key: ArchSampleKeys.todosLoading,
            ))
          : ListView.builder(
              key: ArchSampleKeys.todoList,
              itemCount: filteredTodos.length,
              itemBuilder: (BuildContext context, int index) {
                return BinderScope(
                  overrides: [todoItemRef.overrideWith(filteredTodos[index])],
                  child: const TodoItem(),
                );
              },
            ),
    );
  }
}
