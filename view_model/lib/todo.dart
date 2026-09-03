import 'package:todos_app_core/todos_app_core.dart';

class Todo {
  final bool complete;
  final String id;
  final String note;
  final String task;

  Todo(this.task, {this.complete = false, this.note = '', String? id})
    : id = id ?? Uuid().generateV4();

  Todo copyWith({bool? complete, String? note, String? task}) {
    return Todo(
      task ?? this.task,
      complete: complete ?? this.complete,
      note: note ?? this.note,
      id: id,
    );
  }

  @override
  int get hashCode => Object.hash(complete, id, note, task);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Todo &&
            complete == other.complete &&
            id == other.id &&
            note == other.note &&
            task == other.task;
  }

  @override
  String toString() {
    return 'Todo(complete: $complete, id: $id, note: $note, task: $task)';
  }
}
