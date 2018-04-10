// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

// A poor man's DI. This should be replaced by a proper solution once they
// are more stable.
library dependency_injector;

import 'package:path_provider/path_provider.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:todos_repository_flutter/todos_repository_flutter.dart';

final Injector injector = new Injector._private(
  new ReactiveTodosRepositoryFlutter(
    repository: new TodosRepositoryFlutter(
      fileStorage: new FileStorage(
        '__Todos_Bloc_App__',
        getApplicationDocumentsDirectory,
      ),
    ),
  ),
);

class Injector {
  final ReactiveTodosRepository repository;

  Injector._private(this.repository);
}
