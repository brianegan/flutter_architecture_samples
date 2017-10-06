import 'package:flutter_mvc/src/models.dart';

class FlutterMvcStrings {
  static final String todos = "Todos";
  static final String stats = "Stats";
  static final String all = "Show All";
  static final String active = "Show Active";
  static final String completed = "Show Completed";
  static final String hintText = "What needs to be done?";
  static final String markAllComplete = "Mark all complete";
  static final String markAllIncomplete = "Mark all incomplete";
  static final String clearCompleted = "Clear completed";
  static final String addTodo = "Add Todo";
  static final String editTodo = "Edit Todo";
  static final String saveChanges = "Save changes";
  static final String filterTodos = "Filter todos";

  static String itemsLeft(int numTodos) {
    return '$numTodos item${numTodos != 1 ? 's' : ''} left';
  }

  static String tabTitle(AppTab tab) => tab == AppTab.todos ? todos : stats;
}
