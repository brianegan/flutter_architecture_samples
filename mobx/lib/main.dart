import 'package:flutter/material.dart';
import 'package:mobx_sample/model/layout.dart';
import 'package:mobx_sample/model/todo_list.dart';
import 'package:mobx_sample/routes.dart';
import 'package:provider/provider.dart';

final todoList = TodoList();
final layoutStore = LayoutStore();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TodoList>.value(value: todoList),
        Provider<LayoutStore>.value(value: layoutStore)
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: routes,
      ),
    );
  }
}
