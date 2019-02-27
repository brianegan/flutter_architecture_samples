import 'package:built_value/serializer.dart';
import 'package:redurx_sample/models/todo.dart';
import 'package:test/test.dart';

void main() {
  group('Todo', () {
    test('should have a serializer', () {
      expect(Todo.serializer, TypeMatcher<Serializer<Todo>>());
    });
  });
}
