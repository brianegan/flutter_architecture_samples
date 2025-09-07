import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model_sample/app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localStorage = kIsWeb
      ? KeyValueStorage(
          'scoped_model_todos',
          await SharedPreferences.getInstance(),
        )
      : FileStorage('scoped_model_todos', getApplicationDocumentsDirectory);

  runApp(
    ScopedModelApp(
      repository: LocalStorageRepository(localStorage: localStorage),
    ),
  );
}
