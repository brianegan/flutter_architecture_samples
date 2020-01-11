// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:change_notifier_provider_sample/app.dart';
import 'package:flutter/material.dart';
import 'package:key_value_store_flutter/key_value_store_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_repository_simple/todos_repository_simple.dart';

Future<void> main() async {
  runApp(ProviderApp(
    repository: LocalStorageRepository(
      localStorage: LocalStorage(
        'change_notifier_provider_todos',
        FlutterKeyValueStore(await SharedPreferences.getInstance()),
      ),
    ),
  ));
}
