import 'package:mobx/mobx.dart';
import 'package:todos_app_core/todos_app_core.dart';

part 'todo.g.dart';

/// A reactive class that holds information about a task that needs to be
/// completed
class Todo = _Todo with _$Todo;

abstract class _Todo with Store {
  _Todo({
    String id,
    this.task = '',
    this.note = '',
    this.complete = false,
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
      other is _Todo &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          task == other.task &&
          note == other.note &&
          complete == other.complete;

  @override
  int get hashCode =>
      id.hashCode ^ task.hashCode ^ note.hashCode ^ complete.hashCode;
}
