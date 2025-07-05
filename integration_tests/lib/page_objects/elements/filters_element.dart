// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';

import 'test_element.dart';

class FiltersElement extends TestElement {
  final _allFilter = find.byValueKey('__allFilter__');
  final _activeFilter = find.byValueKey('__activeFilter__');
  final _completedFilter = find.byValueKey('__completedFilter__');

  FiltersElement(FlutterDriver driver) : super(driver);

  Future<void> tapShowAll() async => await driver.tap(_allFilter);

  Future<void> tapShowActive() async => await driver.tap(_activeFilter);

  Future<void> tapShowCompleted() async {
    return await driver.tap(_completedFilter);
  }
}
