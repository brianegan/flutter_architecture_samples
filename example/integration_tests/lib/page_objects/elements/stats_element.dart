// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';

import 'test_element.dart';

class StatsElement extends TestElement {
  final _activeItemsFinder = find.byValueKey('__statsActiveItems__');
  final _completedItemsFinder = find.byValueKey('__statsCompletedItems__');

  StatsElement(FlutterDriver driver) : super(driver);

  Future<int> get numActive async =>
      int.parse((await driver.getText(_activeItemsFinder)));

  Future<int> get numCompleted async =>
      int.parse((await driver.getText(_completedItemsFinder)));
}
