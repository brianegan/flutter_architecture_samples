// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:simple_bloc_flutter_sample/main.dart' as app;
import 'package:simple_blocs/simple_blocs.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:todos_repository_flutter/todos_repository_flutter.dart';

void main() {
  app.main(
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
