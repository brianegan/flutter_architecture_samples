import 'package:flutter/cupertino.dart';
import 'package:mobx_sample/add_todo_page.dart';
import 'package:mobx_sample/home_page.dart';
import 'package:mobx_sample/main.dart';
import 'package:mobx_sample/model/todo.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => HomePage(),
  '/addTodo': (context) =>
      AddTodoPage(
        onAdd: (Todo todo) {
          todoList.addTodo(todo);
          Navigator.pop(context);
        },
      )
}