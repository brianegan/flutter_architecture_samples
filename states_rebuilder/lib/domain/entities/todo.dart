import 'package:todos_app_core/todos_app_core.dart' as flutter_arch_sample_app;

import '../exceptions/validation_exception.dart';

//Entity is a mutable object with an ID. It should contain all the logic It controls.
//Entity is validated just before persistance, ie, in toMap() method.
class Todo {
  String _id;
  String get id => _id;
  final bool complete;
  final String note;
  final String task;

  Todo(this.task, {String id, this.note, this.complete = false})
      : _id = id ?? flutter_arch_sample_app.Uuid().generateV4();

  factory Todo.fromJson(Map<String, Object> map) {
    return Todo(
      map['task'] as String,
      note: map['note'] as String,
      complete: map['complete'] as bool,
    );
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
    if (_id == null) {
      // Custom defined error classes
      throw ValidationException('This todo has no ID!');
    }
    if (task == null || task.isEmpty) {
      throw ValidationException('Empty task are not allowed');
    }
  }

  Todo copyWith({
    String task,
    String note,
    bool complete,
    String id,
  }) {
    return Todo(
      task ?? this.task,
      id: id ?? this.id,
      note: note ?? this.note,
      complete: complete ?? this.complete,
    );
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Todo &&
        o._id == _id &&
        o.complete == complete &&
        o.note == note &&
        o.task == task;
  }

  @override
  int get hashCode {
    return _id.hashCode ^ complete.hashCode ^ note.hashCode ^ task.hashCode;
  }

  @override
  String toString() {
    return 'Todo(id: $id,task:$task, complete: $complete)';
  }
}
