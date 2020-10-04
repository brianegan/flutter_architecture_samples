// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:rvms_model_sample/display_todos/_model/todo.dart';

abstract class TodoManager {
  ValueListenable<List<Todo>> get filteredTodos;
  ValueListenable<List<Todo>> get allTodos;

  Command<VisibilityFilter, VisibilityFilter> selectFilterCommand;
  Command<void, void> loadTodoCommand;
  Command<void, void> clearCompletedCommand;
  Command<String, String> upLoadCommand;

  VisibilityFilter get activeFilter;

  void toggleAll();

  /// updates a [Todo] by replacing the item with the same id by the parameter [todo]
  void updateTodo(Todo todo);

  void removeTodo(Todo todo);

  void addTodo(Todo todo);

  Todo todoById(String id);
}

enum VisibilityFilter { all, active, completed }
