import 'package:flutter_architecture_samples/uuid.dart';
import 'package:meta/meta.dart';

@immutable
class Todo {
  final bool complete;
  final String id;
  final String note;
  final String task;

  Todo(this.task, {this.complete = false, String note = '', String id})
      : this.note = note ?? '',
        this.id = id ?? new Uuid().generateV4();

  Todo copyWith({bool complete, String id, String note, String task}) {
    return new Todo(
      task ?? this.task,
      complete: complete ?? this.complete,
      id: id ?? this.id,
      note: note ?? this.note,
    );
  }

  @override
  int get hashCode =>
      complete.hashCode ^ task.hashCode ^ note.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Todo &&
              runtimeType == other.runtimeType &&
              complete == other.complete &&
              task == other.task &&
              note == other.note &&
              id == other.id;

  Map<String, Object> toJson() {
    return {
      "complete": complete,
      "task": task,
      "note": note,
      "id": id,
    };
  }

  @override
  String toString() {
    return 'Todo{complete: $complete, task: $task, note: $note, id: $id}';
  }

  static Todo fromJson(Map<String, Object> json) {
    return new Todo(
      json["task"] as String,
      complete: json["complete"] as bool,
      note: json["note"] as String,
      id: json["id"] as String,
    );
  }
}