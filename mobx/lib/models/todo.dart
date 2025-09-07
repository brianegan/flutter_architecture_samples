import 'package:mobx/mobx.dart';
import 'package:todos_app_core/todos_app_core.dart';

part 'todo.g.dart';

/// A reactive class that holds information about a task that needs to be
/// completed
class Todo = TodoBase with _$Todo;

abstract class TodoBase with Store {
  TodoBase({
    String? id,
    this.task = '', // ignore: unused_element_parameter
    this.note = '', // ignore: unused_element_parameter
    this.complete = false, // ignore: unused_element_parameter
  }) : id = id ?? Uuid().generateV4();

  final String id;

  @observable
  String task;

  @observable
  String note;

  @observable
  bool complete;

  @override
  String toString() {
    return '_Todo{id: $id, task: $task, note: $note, complete: $complete}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoBase &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          task == other.task &&
          note == other.note &&
          complete == other.complete;

  @override
  int get hashCode =>
      id.hashCode ^ task.hashCode ^ note.hashCode ^ complete.hashCode;
}
