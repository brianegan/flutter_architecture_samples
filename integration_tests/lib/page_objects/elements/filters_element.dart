// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_element.dart';

class FiltersElement extends TestElement {
  final _allFilter = find.byKey(ValueKey('__allFilter__'));
  final _activeFilter = find.byKey(ValueKey('__activeFilter__'));
  final _completedFilter = find.byKey(ValueKey('__completedFilter__'));

  FiltersElement(WidgetTester tester) : super(tester);

  Future<void> tapShowAll() async {
    await tester.tap(_allFilter);
    await tester.pumpAndSettle();
  }

  Future<void> tapShowActive() async {
    await tester.tap(_activeFilter);
    await tester.pumpAndSettle();
  }

  Future<void> tapShowCompleted() async {
    await tester.tap(_completedFilter);
    await tester.pumpAndSettle();
  }
}
