// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter_driver/flutter_driver.dart';

abstract class TestElement {
  final FlutterDriver driver;

  TestElement(this.driver);
}
