import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_architecture_samples/uuid.dart';

part 'todo.g.dart';

abstract class Todo implements Built<Todo, TodoBuilder> {
  static Serializer<Todo> get serializer => _$todoSerializer;

  bool get complete;

  String get id;

  String get note;

  String get task;

  Todo._();

  factory Todo(String task) {
    return _$Todo._(
      task: task,
      complete: false,
      note: '',
      id: Uuid().generateV4(),
    );
  }

  factory Todo.builder([updates(TodoBuilder b)]) {
    final builder = TodoBuilder()
      ..id = Uuid().generateV4()
      ..complete = false
      ..note = ''
      ..update(updates);

    return builder.build();
  }
}
