import 'package:flutter_architecture_samples/uuid.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:todos_repository/todos_repository.dart';

enum AppTab { todos, stats }

enum ExtraAction { toggleAllComplete, clearCompleted }

class TodoModel extends Model {
  bool _complete;
  String _id;
  String _note;
  String _task;

  TodoModel(String task, {bool complete = false, String note = '', String id})
      : this._task = task,
        this._note = note,
        this._complete = complete,
        this._id = id ?? new Uuid().generateV4();

  bool get complete => _complete;

  String get id => _id;

  String get note => _note;

  String get task => _task;

  void set complete(bool isComplete) {
    _complete = isComplete;
    notifyListeners();
  }

  void set id(String newId) {
    _id = newId;
    notifyListeners();
  }

  void set note(String newNote) {
    _note = newNote;
    notifyListeners();
  }

  void set task(String newTask) {
    _task = newTask;
    notifyListeners();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoModel &&
          runtimeType == other.runtimeType &&
          _complete == other._complete &&
          _id == other._id &&
          _note == other._note &&
          _task == other._task;

  @override
  int get hashCode =>
      _complete.hashCode ^ _id.hashCode ^ _note.hashCode ^ _task.hashCode;

  @override
  String toString() {
    return 'Todo{complete: $complete, task: $task, note: $note, id: $id}';
  }

  TodoEntity toEntity() {
    return new TodoEntity(task, id, note, complete);
  }

  static TodoModel fromEntity(TodoEntity entity) {
    return new TodoModel(
      entity.task,
      complete: entity.complete ?? false,
      note: entity.note,
      id: entity.id,
    );
  }
}
