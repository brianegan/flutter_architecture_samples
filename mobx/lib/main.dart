import 'package:flutter/material.dart';
import 'package:mobx_sample/add_todo_page.dart';
import 'package:mobx_sample/home_page.dart';
import 'package:mobx_sample/model/todo.dart';
import 'package:mobx_sample/model/todo_list.dart';
import 'package:provider/provider.dart';

final todoList = TodoList();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<TodoList>.value(
      value: todoList,
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          HomePage.routeName: (context) => HomePage(),
          AddTodoPage.routeName: (context) => AddTodoPage(
                onAdd: (Todo todo) {
                  todoList.addTodo(todo);
                  Navigator.pop(context);
                },
              )
        },
      ),
    );
  }
}
