import 'package:todos_app_core/todos_app_core.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

enum AppTab { todos, stats }

enum ExtraAction { toggleAllComplete, clearCompleted }

class Todo {
  final bool complete;
  final String id;
  final String note;
  final String task;

  Todo(this.task, {this.complete = false, this.note = '', String? id})
    : id = id ?? Uuid().generateV4();

  @override
  int get hashCode => Object.hash(complete, task, note, id);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Todo &&
          runtimeType == other.runtimeType &&
          complete == other.complete &&
          task == other.task &&
          note == other.note &&
          id == other.id;

  @override
  String toString() {
    return 'Todo{complete: $complete, task: $task, note: $note, id: $id}';
  }

  TodoEntity toEntity() {
    return TodoEntity(task, id, note, complete);
  }

  static Todo fromEntity(TodoEntity entity) {
    return Todo(
      entity.task,
      complete: entity.complete,
      note: entity.note,
      id: entity.id,
    );
  }

  Todo copy({String? task, bool? complete, String? note, String? id}) {
    return Todo(
      task ?? this.task,
      complete: complete ?? this.complete,
      note: note ?? this.note,
      id: id ?? this.id,
    );
  }
}
