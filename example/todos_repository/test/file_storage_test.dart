import 'dart:async';
import 'dart:io';

import 'package:test/test.dart';
import 'package:todos_repository/todos_repository.dart';

main() {
  group('FileStorage', () {
    final todos = [new TodoEntity("Task", "1", "Hallo", false)];
    final directory = Directory.systemTemp.createTemp('__storage_test__');
    final storage = new FileStorage(
      '_test_tag_',
      () => directory,
    );

    tearDownAll(() async {
      final tempDirectory = await directory;

      tempDirectory.deleteSync(recursive: true);
    });

    test('Should persist TodoEntities to disk', () async {
      final file = await storage.saveTodos(todos);

      expect(file.existsSync(), isTrue);
    });

    test('Should load TodoEntities from disk', () async {
      final loadedTodos = await storage.loadTodos();

      expect(loadedTodos, todos);
    });
  });
}
