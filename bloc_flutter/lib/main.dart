import 'dart:async';

import 'package:bloc_flutter_sample/anonymous_user_repository.dart';
import 'package:bloc_flutter_sample/app.dart';
import 'package:blocs/blocs.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    BlocApp(
      todosInteractor: TodosInteractor(
        ReactiveLocalStorageRepository(
          repository: LocalStorageRepository(
            localStorage: KeyValueStorage(
              'bloc_todos',
              await SharedPreferences.getInstance(),
            ),
          ),
        ),
      ),
      userRepository: AnonymousUserRepository(),
    ),
  );
}
