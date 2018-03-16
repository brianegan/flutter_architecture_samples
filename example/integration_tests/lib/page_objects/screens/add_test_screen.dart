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

  AddTestScreen(FlutterDriver driver) : super(driver);

  @override
  Future<bool> isReady({Duration timeout}) =>
      widgetExists(driver, _addScreenFinder);

  Future<Null> tapBackButton() async {
    await driver.tap(_backButtonFinder);

    return this;
  }
}
