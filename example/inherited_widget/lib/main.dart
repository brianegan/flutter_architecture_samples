// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:inherited_widget_sample/app.dart';
import 'package:inherited_widget_sample/state_container.dart';

void main() {
  runApp(StateContainer(
    child: InheritedWidgetApp(),
  ));
}
