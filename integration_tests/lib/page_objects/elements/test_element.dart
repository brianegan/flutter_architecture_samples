// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';

abstract class TestElement {
  final WidgetTester tester;

  TestElement(this.tester);
}
