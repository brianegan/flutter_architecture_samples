import 'package:flutter/cupertino.dart';
import 'package:mobx_sample/add_todo_page.dart';
import 'package:mobx_sample/home_page.dart';
import 'package:mobx_sample/main.dart';
import 'package:mobx_sample/store/todo.dart';

const homePageRoute = '/';
const addTodoPageRoute = '/addTodo';

final Map<String, WidgetBuilder> routes = {
  homePageRoute: (context) => HomePage(),
  addTodoPageRoute: (context) => AddTodoPage(
        onAdd: (Todo todo) {
          todoList.addTodo(todo);
          Navigator.pop(context);
        },
      )
};
