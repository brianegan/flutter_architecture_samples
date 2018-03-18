import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_architecture_samples/uuid.dart';
import 'package:meta/meta.dart';
import 'package:todos_repository/todos_repository.dart';

// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

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

  @override
  String toString() {
    return 'Todo{complete: $complete, task: $task, note: $note, id: $id}';
  }

  Map<String, dynamic> toMap() {
    return {
      'complete': complete,
      'task': task,
      'note': note,
    };
  }

  static Todo fromEntity(TodoEntity entity) {
    return new Todo(
      entity.task,
      complete: entity.complete ?? false,
      note: entity.note,
      id: entity.id ?? new Uuid().generateV4(),
    );
  }

  static Todo fromDocument(DocumentSnapshot doc) {
    return new Todo(
      doc['task'],
      complete: doc['complete'] ?? false,
      id: doc.documentID,
      note: doc['note'] ?? '',
    );
  }
}
