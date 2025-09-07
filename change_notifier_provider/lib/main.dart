import 'package:change_notifier_provider_sample/app.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderApp(
      repository: LocalStorageRepository(
        localStorage: KeyValueStorage(
          'change_notifier_provider_todos',
          await SharedPreferences.getInstance(),
        ),
      ),
    ),
  );
}
