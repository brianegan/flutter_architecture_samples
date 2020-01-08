// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

library todo;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:todos_app_core/todos_app_core.dart';

part 'todo.g.dart';

abstract class Todo implements Built<Todo, TodoBuilder> {
  static Serializer<Todo> get serializer => _$todoSerializer;

  bool get complete;

  String get id;

  String get note;

  String get task;

  Todo._();

  factory Todo(String task) {
    return _$Todo._(
      task: task,
      complete: false,
      note: '',
      id: Uuid().generateV4(),
    );
  }

  factory Todo.builder([void Function(TodoBuilder b) updates]) {
    final builder = TodoBuilder()
      ..id = Uuid().generateV4()
      ..complete = false
      ..note = ''
      ..update(updates);

    return builder.build();
  }
}
