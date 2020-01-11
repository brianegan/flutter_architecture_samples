// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:inherited_widget_sample/app.dart';
import 'package:inherited_widget_sample/state_container.dart';
import 'package:key_value_store_flutter/key_value_store_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_repository_simple/todos_repository_simple.dart';

Future<void> main() async {
  runApp(StateContainer(
    child: const InheritedWidgetApp(),
    repository: LocalStorageRepository(
      localStorage: LocalStorage(
        'inherited_widget_todos',
        FlutterKeyValueStore(await SharedPreferences.getInstance()),
      ),
    ),
  ));
}
