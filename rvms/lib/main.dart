// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:rvms_model_sample/locator.dart';
import 'package:rvms_model_sample/startup/app.dart';

void main() {
  initLocator();
  runApp(RvmsApp());
}
