// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model_sample/app.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  var todoRepo = const LocalStorageRepository(
    localStorage: FileStorage(
      'scoped_model_todos',
      getApplicationDocumentsDirectory,
    ),
  );

  runApp(ScopedModelApp(
    repository: todoRepo,
  ));
}
