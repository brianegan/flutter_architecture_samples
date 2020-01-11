import 'dart:html';

import 'package:bloc_library/run_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:key_value_store_web/key_value_store_web.dart';
import 'package:todos_repository_simple/todos_repository_simple.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runBlocLibraryApp(LocalStorageRepository(
    localStorage: LocalStorage(
      'bloc_library',
      WebKeyValueStore(window.localStorage),
    ),
  ));
}
