import 'package:flutter/material.dart';
import 'package:mobx_sample/model/todo_manager_store.dart';
import 'package:mobx_sample/routes.dart';
import 'package:provider/provider.dart';

final todoList = TodoManagerStore();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TodoManagerStore>.value(value: todoList),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: routes,
      ),
    );
  }
}
