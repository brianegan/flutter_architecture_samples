// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';
import 'package:todos_repository_core/todos_repository_core.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

class MocktailKeyValueStore extends Mock implements SharedPreferences {}

void main() {
  group('KeyValueStorage', () {
    final todos = [TodoEntity('Task', '1', 'Hallo', true)];
    final todosJson =
        '{"todos":[{"complete":true,"task":"Task","note":"Hallo","id":"1"}]}';

    test('Should persist TodoEntities to the store', () async {
      final store = MocktailKeyValueStore();
      final storage = KeyValueStorage('T', store);

      when(() => store.setString('T', todosJson)).thenAnswer((_) async {
        return true;
      });

      await storage.saveTodos(todos);

      verify(() => store.setString('T', todosJson));
    });

    test('Should load TodoEntities from disk', () async {
      final store = MocktailKeyValueStore();
      final storage = KeyValueStorage('T', store);

      when(() => store.getString('T')).thenReturn(todosJson);

      expect(await storage.loadTodos(), todos);
    });
  });
}
