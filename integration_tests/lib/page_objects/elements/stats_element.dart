// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_element.dart';

class StatsElement extends TestElement {
  final _activeItemsFinder = find.byKey(ValueKey('__statsActiveItems__'));
  final _completedItemsFinder = find.byKey(ValueKey('__statsCompletedItems__'));

  StatsElement(WidgetTester tester) : super(tester);

  Future<int> get numActive async =>
      int.parse(tester.widget<Text>(_activeItemsFinder).data!);

  Future<int> get numCompleted async =>
      int.parse(tester.widget<Text>(_completedItemsFinder).data!);
}
