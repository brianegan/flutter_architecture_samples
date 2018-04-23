// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:mvi_base/mvi_base.dart';
import 'package:mvi_flutter_sample/main.dart' as app;
import 'package:path_provider/path_provider.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:todos_repository_flutter/todos_repository_flutter.dart';

void main() {
  app.main(
    todosRepository: new TodosInteractor(
      new ReactiveTodosRepositoryFlutter(
        repository: new TodosRepositoryFlutter(
          fileStorage: new FileStorage(
            '__bloc_local_storage',
            getApplicationDocumentsDirectory,
          ),
        ),
      ),
    ),
    userInteractor: new UserInteractor(AnonymousUserRepository()),
  );
}

class AnonymousUserRepository implements UserRepository {
  @override
  Future<UserEntity> login() {
    return new Future.value(new UserEntity(id: 'anonymous'));
  }
}
