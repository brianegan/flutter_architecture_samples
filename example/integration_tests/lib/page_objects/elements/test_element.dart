// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter_driver/flutter_driver.dart';

abstract class TestElement {
  // increase default driver command timeout from 5 to 20
  // used by elements that have timeouts running on CI
  final Duration timeout = Duration(seconds: 20);
  final FlutterDriver driver;

  TestElement(this.driver);
}
