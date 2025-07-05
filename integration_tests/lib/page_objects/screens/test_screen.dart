// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';

abstract class TestScreen {
  final WidgetTester tester;

  TestScreen(this.tester);

  Future<bool> isLoading() async {
    return !(await isReady());
  }

  Future<bool> isReady();
}
