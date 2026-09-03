import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';
import 'package:view_model/view_model.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ViewModel.initialize();

  runApp(
    ViewModelApp(
      repository: LocalStorageRepository(
        localStorage: KeyValueStorage(
          'view_model_todos',
          await SharedPreferences.getInstance(),
        ),
      ),
    ),
  );
}
