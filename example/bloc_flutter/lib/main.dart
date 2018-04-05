// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:bloc_flutter_sample/app.dart';
import 'package:bloc_flutter_sample/todos_bloc_provider.dart';
import 'package:blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todos_repository_flutter/todos_repository_flutter.dart';

void main() {
  runApp(new TodosBlocProvider(
    child: new BlocApp(),
    bloc: new TodosBloc(
      new ReactiveTodosRepositoryFlutter(
        repository: new TodosRepositoryFlutter(
          fileStorage: new FileStorage(
            '__Todos_Bloc_App__',
            getApplicationDocumentsDirectory,
          ),
        ),
      ),
    ),
  ));
}
