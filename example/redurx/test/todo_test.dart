import 'package:built_value/serializer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redurx_sample/models/todo.dart';

void main() {
  group('Todo', () {
    test('should have a serializer', () {
      expect(Todo.serializer, isInstanceOf<Serializer<Todo>>());
    });
  });
}
