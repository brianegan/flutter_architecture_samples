// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:bloc_flutter_sample/app.dart';
import 'package:blocs/blocs.dart';
import 'package:flutter/widgets.dart';
import 'package:key_value_store_web/key_value_store_web.dart';
import 'package:todos_repository_core/todos_repository_core.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(BlocApp(
    todosInteractor: TodosInteractor(
      ReactiveLocalStorageRepository(
        repository: LocalStorageRepository(
          localStorage: KeyValueStorage(
            'bloc_todos',
            WebKeyValueStore(window.localStorage),
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
