// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todos_repository_simple/todos_repository_simple.dart';
import 'package:vanilla/app.dart';

void main() {
  runApp(
    VanillaApp(
      repository: TodosRepositoryFlutter(
        fileStorage: FileStorage(
          'vanilla_app',
          getApplicationDocumentsDirectory,
        ),
        webClient: WebClient(),
      ),
    ),
  );
}
