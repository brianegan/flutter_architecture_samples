import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';
import 'package:vanilla/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    VanillaApp(
      repository: LocalStorageRepository(
        localStorage: KeyValueStorage(
          'vanilla',
          await SharedPreferences.getInstance(),
        ),
      ),
    ),
  );
}
