// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:integration_tests/integration_tests.dart' as integration_tests;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';
import 'package:vanilla/app.dart';

void main() {
  integration_tests.run(appBuilder: () async {
    return VanillaApp(
      repository: LocalStorageRepository(
        localStorage: KeyValueStorage(
          'vanilla_test_${DateTime.now().toIso8601String()}',
          await SharedPreferences.getInstance(),
        ),
      ),
    );
  });
}
