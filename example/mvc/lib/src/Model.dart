// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async' show Future;

/// It is this Model that 'knows of' this class.
/// This is to demonstrate the modular approach and 'separation of responsibilities'
import 'package:mvc/src/todo_list_model.dart'
    show To, TodoListModel, VisibilityFilter;

class Model {
  final todoModel = TodoListModel();

  VisibilityFilter get activeFilter => todoModel.activeFilter;

  set activeFilter(VisibilityFilter filter) {
    todoModel.activeFilter = filter;
  }

  List<Map> get todos => todoModel.todos.map(To.map).toList();

  bool get isLoading => todoModel.isLoading;

  Future loadTodos() {
    return todoModel.loadTodos();
  }

  List<Map> get filteredTodos => todoModel.filteredTodos.map(To.map).toList();

  void clearCompleted() {
    todoModel.clearCompleted();
  }

  void toggleAll() {
    todoModel.toggleAll();
  }

  void removeTodo(Map data) {
    todoModel.removeTodo(To.todo(data));
  }

  void undoRemove(Map data) {
    data['id'] = null;
    update(data);
  }

  void update(Map data) {
    if (data['id'] == null) {
      todoModel.addTodo(To.todo(data));
    } else {
      todoModel.updateTodo(To.todo(data));
    }
  }

  void checkCompleted(Map data) {
    /// The model 'knows' which field is involved when an item is checked.
    data['complete'] = !data['complete'];
    updateTodo(data);
  }

  void updateTodo(Map data) {
    todoModel.updateTodo(To.todo(data));
  }

  void addTodo(Map data) {
    todoModel.addTodo(To.todo(data));
  }

  Map<String, Object> todoById(String id) {
    return To.map(todoModel.todoById(id)).cast<String, Object>();
  }
}
