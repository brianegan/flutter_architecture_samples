// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';
import 'package:vanilla/app.dart';

Future<void> main({String? storageKey}) async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    VanillaApp(
      repository: LocalStorageRepository(
        localStorage: KeyValueStorage(
          storageKey ?? 'vanilla',
          await SharedPreferences.getInstance(),
        ),
      ),
    ),
  );
}
