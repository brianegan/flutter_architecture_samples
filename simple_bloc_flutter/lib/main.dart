import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_bloc_flutter_sample/anonymous_user_repository.dart';
import 'package:simple_bloc_flutter_sample/app.dart';
import 'package:simple_blocs/simple_blocs.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    SimpleBlocApp(
      todosInteractor: TodosInteractor(
        ReactiveLocalStorageRepository(
          repository: LocalStorageRepository(
            localStorage: KeyValueStorage(
              'simple_bloc',
              await SharedPreferences.getInstance(),
            ),
          ),
        ),
      ),
      userRepository: AnonymousUserRepository(),
    ),
  );
}
