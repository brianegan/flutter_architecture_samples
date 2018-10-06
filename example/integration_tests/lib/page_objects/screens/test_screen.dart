// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';

abstract class TestScreen {
  // increase default driver command timeout from 5 to 20
  // used by screens that have timeouts running on CI
  final Duration timeout = const Duration(seconds: 20);
  final FlutterDriver driver;

  TestScreen(this.driver);

  Future<bool> isLoading({Duration timeout}) async {
    return !(await isReady(timeout: timeout));
  }

  Future<bool> isReady({Duration timeout});
}
