// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';
import 'package:todos_repository_core/todos_repository_core.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

import 'key_value_storage_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SharedPreferences>()])
void main() {
  group('KeyValueStorage', () {
    final todos = [TodoEntity('Task', '1', 'Hallo', true)];
    final todosJson =
        '{"todos":[{"complete":true,"task":"Task","note":"Hallo","id":"1"}]}';

    test('Should persist TodoEntities to the store', () async {
      final prefs = MockSharedPreferences();
      final storage = KeyValueStorage('T', prefs);

      await storage.saveTodos(todos);

      verify(prefs.setString('T', todosJson));
    });

    test('Should load TodoEntities from disk', () async {
      final prefs = MockSharedPreferences();
      final storage = KeyValueStorage('T', prefs);

      when(prefs.getString('T')).thenReturn(todosJson);

      expect(await storage.loadTodos(), todos);
    });
  });
}
