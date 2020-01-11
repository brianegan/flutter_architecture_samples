// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:key_value_store/key_value_store.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:todos_repository_core/todos_repository_core.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

class MockKeyValueStore extends Mock implements KeyValueStore {}

void main() {
  group('KeyValueStorage', () {
    final store = MockKeyValueStore();
    final todos = [TodoEntity('Task', '1', 'Hallo', true)];
    final todosJson =
        '{"todos":[{"complete":true,"task":"Task","note":"Hallo","id":"1"}]}';
    final storage = KeyValueStorage('T', store);

    test('Should persist TodoEntities to the store', () async {
      await storage.saveTodos(todos);

      verify(store.setString('T', todosJson));
    });

    test('Should load TodoEntities from disk', () async {
      when(store.getString('T')).thenReturn(todosJson);

      expect(await storage.loadTodos(), todos);
    });
  });
}
