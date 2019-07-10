import 'package:flutter/material.dart';
import 'package:mobx_sample/home_page.dart';
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
        home: HomePage(),
      ),
    );
  }
}
