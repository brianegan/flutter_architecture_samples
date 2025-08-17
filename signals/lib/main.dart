import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    SignalsApp(
      repository: LocalStorageRepository(
        localStorage: KeyValueStorage(
          'mobx_todos',
          await SharedPreferences.getInstance(),
        ),
      ),
    ),
  );
}
