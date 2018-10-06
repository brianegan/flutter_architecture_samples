// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';

import '../screens/details_test_screen.dart';
import '../utils.dart';
import 'test_element.dart';

class TodoItemElement extends TestElement {
  final String id;

  TodoItemElement(this.id, FlutterDriver driver) : super(driver);

  SerializableFinder get _taskFinder =>
      find.byValueKey('TodoItem__${id}__Task');

  SerializableFinder get _checkboxFinder =>
      find.byValueKey('TodoItem__${id}__Checkbox');

  SerializableFinder get _todoItemFinder => find.byValueKey('TodoItem__${id}');

  Future<bool> get isVisible =>
      widgetExists(driver, _todoItemFinder, timeout: timeout);

  Future<bool> get isAbsent =>
      widgetAbsent(driver, _todoItemFinder, timeout: timeout);

  Future<String> get task async =>
      await driver.getText(_taskFinder, timeout: timeout);

  Future<String> get note async => await driver
      .getText(find.byValueKey('TodoItem__${id}__Note'), timeout: timeout);

  Future<TodoItemElement> tapCheckbox() async {
    await driver.tap(_checkboxFinder, timeout: timeout);
    await driver.waitUntilNoTransientCallbacks(timeout: timeout);

    return this;
  }

  DetailsTestScreen tap() {
    driver.tap(_taskFinder, timeout: timeout);

    return new DetailsTestScreen(driver);
  }
}
