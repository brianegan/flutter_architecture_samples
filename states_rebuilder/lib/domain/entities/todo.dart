import 'package:todos_app_core/todos_app_core.dart' as flutter_arch_sample_app;

import '../exceptions/validation_exception.dart';

//Entity is a mutable object with an ID. It should contain all the logic It controls.
//Entity is validated just before persistance, ie, in toMap() method.
class Todo {
  String id;
  bool complete;
  String note;
  String task;

  Todo(this.task, {String id, this.note, this.complete = false})
      : id = id ?? flutter_arch_sample_app.Uuid().generateV4();

  Todo.fromJson(Map<String, Object> map) {
    id = map['id'] as String;
    task = map['task'] as String;
    note = map['note'] as String;
    complete = map['complete'] as bool;
  }

  // toJson is called just before persistance.
  Map<String, Object> toJson() {
    _validation();
    return {
      'complete': complete,
      'task': task,
      'note': note,
      'id': id,
    };
  }

  void _validation() {
    if (id == null) {
      // Custom defined error classes
      throw ValidationException('This todo has no ID!');
    }
    if (task == null || task.isEmpty) {
      throw ValidationException('Empty task are not allowed');
    }
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Todo && runtimeType == other.runtimeType && id == other.id;
}
