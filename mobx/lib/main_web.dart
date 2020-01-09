import 'dart:html';

import 'package:flutter/material.dart';
import 'package:key_value_store_web/key_value_store_web.dart';
import 'package:todos_repository_simple/todos_repository_simple.dart';

import 'app.dart';

Future<void> main() async {
  runApp(
    MobxApp(
      repository: LocalStorageRepository(
        localStorage: LocalStorage(
          'mobx_todos',
          WebKeyValueStore(window.localStorage),
        ),
      ),
    ),
  );
}
