import 'package:bloc_library/run_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:key_value_store_flutter/key_value_store_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runBlocLibraryApp(LocalStorageRepository(
    localStorage: KeyValueStorage(
      'bloc_library',
      FlutterKeyValueStore(await SharedPreferences.getInstance()),
    ),
  ));
}
