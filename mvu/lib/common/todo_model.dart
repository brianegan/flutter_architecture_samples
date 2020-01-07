import 'package:built_value/built_value.dart';

import 'package:todos_app_core/todos_app_core.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

part 'todo_model.g.dart';

abstract class TodoModel implements Built<TodoModel, TodoModelBuilder> {
  String get id;
  bool get complete;
  String get note;
  String get task;

  TodoModel._();
  factory TodoModel([void Function(TodoModelBuilder b) updates]) = _$TodoModel;

  TodoEntity toEntity() {
    return TodoEntity(task, id, note, complete);
  }

  static TodoModel fromEntity(TodoEntity entity) {
    var model = TodoModel((b) => b
      ..task = entity.task
      ..complete = entity.complete
      ..note = entity.note
      ..id = entity.id ?? Uuid().generateV4());
    return model;
  }
}
