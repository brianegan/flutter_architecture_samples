// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';

import '../utils.dart';
import 'test_element.dart';
import 'todo_item_element.dart';

class TodoListElement extends TestElement {
  final _todoListFinder = find.byValueKey('__todoList__');
  final _loadingFinder = find.byValueKey('__todosLoading__');

  TodoListElement(FlutterDriver driver) : super(driver);

  Future<bool> get isLoading {
    // We need to run this command "unsynchronized". This means it immediately
    // checks if the loading widget is on screen, rather than waiting for any
    // pending animations to complete.
    //
    // Since the CircularProgressIndicator runs a continuous animation, if we
    // do not `runUnsynchronized`, this check will never work.
    return driver.runUnsynchronized(() {
      return widgetExists(driver, _loadingFinder);
    });
  }

  Future<bool> get isReady => widgetExists(driver, _todoListFinder);

  TodoItemElement todoItem(String id) => TodoItemElement(id, driver);

  TodoItemElement todoItemAbsent(String id) => TodoItemElement(id, driver);
}
