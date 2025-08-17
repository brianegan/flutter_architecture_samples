import 'package:signals/signals.dart';
import 'package:todos_app_core/todos_app_core.dart';

class Todo {
  final Signal<bool> complete;
  final Signal<String> id;
  final Signal<String> note;
  final Signal<String> task;

  Todo(String task, {bool complete = false, String note = '', String? id})
    : task = Signal(task),
      complete = Signal(complete),
      note = Signal(note),
      id = Signal(id ?? Uuid().generateV4());

  @override
  int get hashCode =>
      complete.value.hashCode ^
      task.value.hashCode ^
      note.value.hashCode ^
      id.value.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Todo &&
          runtimeType == other.runtimeType &&
          complete.value == other.complete.value &&
          task.value == other.task.value &&
          note.value == other.note.value &&
          id.value == other.id.value;

  @override
  String toString() {
    return 'Todo{complete: ${complete.value}, task: ${task.value}, note: ${note.value}, id: ${id.value}}';
  }
}
