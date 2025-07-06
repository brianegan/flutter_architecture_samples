import 'package:flutter/material.dart';
import 'package:inherited_widget_sample/app.dart';
import 'package:inherited_widget_sample/state_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    StateContainer(
      repository: LocalStorageRepository(
        localStorage: KeyValueStorage(
          'inherited_widget_todos',
          await SharedPreferences.getInstance(),
        ),
      ),
      child: const InheritedWidgetApp(),
    ),
  );
}
