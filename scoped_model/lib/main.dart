// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model_sample/app.dart';
import 'package:todos_repository_simple/todos_repository_simple.dart';

void main() {
  var todoRepo = const TodosRepositoryFlutter(
    fileStorage: FileStorage(
      'scoped_model_todos',
      getApplicationDocumentsDirectory,
    ),
  );

  runApp(ScopedModelApp(
    repository: todoRepo,
  ));
}
