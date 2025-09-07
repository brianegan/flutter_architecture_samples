import 'package:bloc/bloc.dart';
import 'package:bloc_library/app.dart';
import 'package:bloc_library/blocs/simple_bloc_observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // BlocObserver oversees Blocs and delegates to BlocDelegate.
  // We can set the BlocSupervisor's delegate to an instance of `SimpleBlocDelegate`.
  // This will allow us to handle all transitions and errors in SimpleBlocDelegate.
  Bloc.observer = SimpleBlocObserver();

  runApp(
    TodosApp(
      repository: LocalStorageRepository(
        localStorage: KeyValueStorage(
          'bloc_library',
          await SharedPreferences.getInstance(),
        ),
      ),
    ),
  );
}
