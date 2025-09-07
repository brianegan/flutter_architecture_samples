import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mvi_base/mvi_base.dart';
import 'package:mvi_flutter_sample/anonymous_user_repository.dart';
import 'package:mvi_flutter_sample/mvi_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MviApp(
      todoListInteractor: TodoListInteractor(
        ReactiveLocalStorageRepository(
          repository: LocalStorageRepository(
            localStorage: KeyValueStorage(
              'mvi_flutter_sample',
              await SharedPreferences.getInstance(),
            ),
          ),
        ),
      ),
      userInteractor: UserInteractor(AnonymousUserRepository()),
    ),
  );
}
