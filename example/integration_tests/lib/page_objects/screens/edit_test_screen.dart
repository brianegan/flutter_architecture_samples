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

  EditTestScreen(FlutterDriver driver) : super(driver);

  @override
  Future<bool> isReady({Duration timeout}) =>
      widgetExists(driver, _editScreenFinder);

  Future<void> tapBackButton() async {
    await driver.tap(_backButtonFinder);
  }
}
