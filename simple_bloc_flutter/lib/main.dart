// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:key_value_store_flutter/key_value_store_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_bloc_flutter_sample/app.dart';
import 'package:simple_blocs/simple_blocs.dart';
import 'package:todos_repository_core/todos_repository_core.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(SimpleBlocApp(
    todosInteractor: TodosInteractor(
      ReactiveLocalStorageRepository(
        repository: LocalStorageRepository(
          localStorage: KeyValueStorage(
            'simple_bloc',
            FlutterKeyValueStore(await SharedPreferences.getInstance()),
          ),
        ),
      ),
    ),
    userRepository: AnonymousUserRepository(),
  ));
}

class AnonymousUserRepository implements UserRepository {
  @override
  Future<UserEntity> login() {
    return Future.value(UserEntity(id: 'anonymous'));
  }
}
