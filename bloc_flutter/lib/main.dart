// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:bloc_flutter_sample/run_bloc_app.dart';
import 'package:blocs/blocs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todos_repository_core/todos_repository_core.dart';
import 'package:todos_repository_simple/todos_repository_simple.dart';

void main() {
  runBlocApp(
    todosInteractor: TodosInteractor(
      ReactiveTodosRepositoryFlutter(
        repository: TodosRepositoryFlutter(
          fileStorage: FileStorage(
            '__bloc_local_storage',
            getApplicationDocumentsDirectory,
          ),
        ),
      ),
    ),
    userRepository: AnonymousUserRepository(),
  );
}

class AnonymousUserRepository implements UserRepository {
  @override
  Future<UserEntity> login() {
    return Future.value(UserEntity(id: 'anonymous'));
  }
}
