// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async' show Future;
import 'package:mvc_pattern/mvc_pattern.dart' show ControllerMVC;

import 'package:mvc/src/todo_list_model.dart' show VisibilityFilter;
import 'package:mvc/src/Model.dart' show Model;

import 'package:mvc/src/App.dart' show MVCApp;

/// The Controller answers & responses to 'the events' while the Model execute 'the rules' and manipulates data.
class Con extends ControllerMVC {
  factory Con() {
    return _this ??= Con._();
  }
  static Con _this;

  Con._();

  /// Allow for easy access to 'the Controller' throughout the application.
  static Con get con => _this;

  static final model = Model();

  static VisibilityFilter get activeFilter => model.activeFilter;
  static set activeFilter(VisibilityFilter filter) =>
      model.activeFilter = filter;

  static List<Map<dynamic, dynamic>> get todos => model.todos;

  static bool get isLoading => model.isLoading;

  String get title => MVCApp.title;

  /// Called by the View.
  void init() => loadData();

  Future loadData() async {
    var load = await model.loadTodos();
    // In this case, it is the Controller that decides to 'refresh' the View.
    refresh();
    return load;
  }

  static List<Map> get filteredTodos => model.filteredTodos;

  void clear() {
    /// Only the Model 'knows' what it done when there's a 'clear' message issued.
    model.clearCompleted();
    // In this case, it is the Controller that decides to 'refresh' the View.
    refresh();
  }

  void toggle() {
    model.toggleAll();
    // In this case, it is the Controller that decides to 'refresh' the View.
    refresh();
  }

  void checked(Map<String, Object> data) {
    /// The Model has the 'business rules' that fire when an item is checked.
    model.checkCompleted(data);
    // In this case, it is the Controller that decides to 'refresh' the View.
    refresh();
  }

  void updateTodo(Map<String, Object> data) {
    model.updateTodo(data);
    // In this case, it is the Controller that decides to 'refresh' the View.
    refresh();
  }

  void remove(Map<String, Object> dataItem) {
    model.removeTodo(dataItem);
    // In this case, it is the Controller that decides to 'refresh' the View.
    refresh();
  }

  void undo(Map<String, Object> dataItem) {
    /// The Model 'knows' how to undo a remove of an item.
    model.undoRemove(dataItem);
    // In this case, it is the Controller that decides to 'refresh' the View.
    refresh();
  }

  void update(Map<String, Object> dataItem) {
    /// Updates the database. Either add a new data item or updating an existing one.
    model.update(dataItem);
    // In this case, it is the Controller that decides to 'refresh' the View.
    refresh();
  }

  void addTodo(Map<String, Object> data) {
    model.addTodo(data);
    // In this case, it is the Controller that decides to 'refresh' the View.
    refresh();
  }

  Map<String, Object> todoById(String id) {
    return model.todoById(id);
  }
}
