import 'dart:async';
import 'package:flutter_driver/src/driver.dart';
import '../utils.dart';
import 'test_element.dart';
import 'todo_item_element.dart';

class TodoListElement extends TestElement {
  final _todoListFinder = find.byValueKey('__todoList__');
  final _loadingFinder = find.byValueKey('__todosLoading__');

  TodoListElement(FlutterDriver driver) : super(driver);

  Future<bool> get isLoading {
    return driver.runUnsynchronized(() {
      return widgetExists(driver, _loadingFinder);
    });
  }

  Future<bool> get isReady => widgetExists(driver, _todoListFinder);

  TodoItemElement todoItem(String id) => new TodoItemElement(id, driver);

  TodoItemElement todoItemAbsent(String id) => new TodoItemElement(id, driver);
}
