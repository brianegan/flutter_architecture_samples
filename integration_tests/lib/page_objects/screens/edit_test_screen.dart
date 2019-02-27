// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';

import '../utils.dart';
import 'test_screen.dart';

class EditTestScreen extends TestScreen {
  final _editScreenFinder = find.byValueKey('__editTodoScreen__');
  final _backButtonFinder = find.byTooltip('Back');
  final _taskFieldFinder = find.byValueKey('__taskField__');
  final _noteFieldFinder = find.byValueKey('__noteField__');
  final _saveFabFinder = find.byValueKey('__saveTodoFab__');

  EditTestScreen(FlutterDriver driver) : super(driver);

  @override
  Future<bool> isReady({Duration timeout}) =>
      widgetExists(driver, _editScreenFinder, timeout: timeout);

  Future<void> tapBackButton() async {
    await driver.tap(_backButtonFinder);
  }

  Future<Null> editTask(String task) async {
    // must set focus to 'enable' keyboard even though focus already set
    await driver.tap(_taskFieldFinder);
    await driver.enterText(task);
    await driver.waitFor(find.text(task));
  }

  Future<Null> editNote(String note) async {
    // must set focus to 'enable' keyboard even though focus already set
    await driver.tap(_noteFieldFinder);
    await driver.enterText(note);
    await driver.waitFor(find.text(note));
  }

  Future<Null> tapSaveFab() async {
    await driver.tap(_saveFabFinder);
  }
}
