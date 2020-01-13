// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:html';

import 'package:flutter/material.dart';
import 'package:key_value_store_web/key_value_store_web.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

import 'app.dart';
import 'data_source/todo_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    StatesRebuilderApp(
      repository: StatesBuilderTodosRepository(
        todosRepository: LocalStorageRepository(
          localStorage: KeyValueStorage(
            'states_rebuilder',
            WebKeyValueStore(window.localStorage),
          ),
        ),
      ),
    ),
  );
}
