import 'dart:html';

import 'package:flutter/material.dart';
import 'package:key_value_store_web/key_value_store_web.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MobxApp(
      repository: LocalStorageRepository(
        localStorage: KeyValueStorage(
          'mobx_todos',
          WebKeyValueStore(window.localStorage),
        ),
      ),
    ),
  );
}
