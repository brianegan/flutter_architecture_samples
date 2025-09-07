import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_library/models/models.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

void main() {
  group('Todo', () {
    test('is correctly generated from TodoEntity', () {
      expect(
        Todo.fromEntity(TodoEntity('task', 'id', 'note', true)),
        Todo('task', id: 'id', note: 'note', complete: true),
      );
    });
  });
}
