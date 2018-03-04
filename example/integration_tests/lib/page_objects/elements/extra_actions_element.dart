// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';

import 'test_element.dart';

class ExtraActionsElement extends TestElement {
  final _toggleAll = find.byValueKey('__markAllDone__');
  final _clearCompleted = find.byValueKey('__clearCompleted__');

  ExtraActionsElement(FlutterDriver driver) : super(driver);

  Future<ExtraActionsElement> tapToggleAll() async {
    await driver.tap(_toggleAll);

    return this;
  }

  Future<ExtraActionsElement> tapClearCompleted() async {
    await driver.tap(_clearCompleted);

    return this;
  }
}
