// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';

import '../utils.dart';
import 'test_screen.dart';

class AddTestScreen extends TestScreen {
  final _addScreenFinder = find.byValueKey('__addTodoScreen__');
  final _backButtonFinder = find.byTooltip('Back');
  final _saveNewButtonFinder = find.byValueKey('__saveNewTodo__');
  final _taskFieldFinder = find.byValueKey('__taskField__');
  final _noteFieldFinder = find.byValueKey('__noteField__');

  AddTestScreen(FlutterDriver driver) : super(driver);

  @override
  Future<bool> isReady({Duration timeout}) =>
      widgetExists(driver, _addScreenFinder);

  Future<Null> tapBackButton() async {
    await driver.tap(_backButtonFinder);

    return this;
  }

  Future<Null> enterTask(String task) async {
    // must set focus to 'enable' keyboard even though focus already set
    await driver.tap(_taskFieldFinder);
    await driver.enterText(task);
    await driver.waitFor(find.text(task));
  }

  Future<Null> enterNote(String note) async {
    // must set focus to 'enable' keyboard even though focus already set
    await driver.tap(_noteFieldFinder);
    await driver.enterText(note);
    await driver.waitFor(find.text(note));
  }

  Future<Null> tapSaveNewButton() async {
    await driver.tap(_saveNewButtonFinder);
  }
}
