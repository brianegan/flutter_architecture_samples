// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:fire_redux_sample/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_driver/driver_extension.dart';

import 'mock_reactive_repository.dart';

void main() {
  enableFlutterDriverExtension();

  runApp(ReduxApp(
    todosRepository: MockReactiveTodosRepository(),
    userRepository: MockUserRepository(),
  ));
}
